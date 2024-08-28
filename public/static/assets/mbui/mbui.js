;!function(win){
  "use strict";

  var doc = win.document;
  var config = {
    modules: {}, // 模块物理路径
    status: {}, // 模块加载状态
    timeout: 10, // 符合规范的模块请求最长等待秒数
    event: {} // 模块自定义事件
  };

  var Mbui = function(){
    this.v = '1.0.1'; // Mbui 版本号
  };

  // 识别预先可能定义的指定全局对象
  var GLOBAL = win.GLOBAL || {};

  // 获取 mbui 所在目录
  var getPath = function(){
    var jsPath = doc.currentScript ? doc.currentScript.src : function(){
      var js = doc.scripts;
      var last = js.length - 1;
      var src;
      for(var i = last; i > 0; i--){
        if(js[i].readyState === 'interactive'){
          src = js[i].src;
          break;
        }
      }
      return src || js[last].src;
    }();

    return config.dir = GLOBAL.dir || jsPath.substring(0, jsPath.lastIndexOf('/') + 1);
  }();

  // 异常提示
  var error = function(msg, type){
    type = type || 'log';
    win.console && console[type] && console[type]('mbui error hint: ' + msg);
  };

  var isOpera = typeof opera !== 'undefined' && opera.toString() === '[object Opera]';

  // 内置模块
  var modules = {};

  // 记录基础数据
  Mbui.prototype.cache = config;

  // 定义模块
  Mbui.prototype.define = function(deps, factory){
    var that = this;
    var type = typeof deps === 'function';
    var callback = function(){
      var setApp = function(app, exports){
        mbui[app] = exports;
        config.status[app] = true;
      };
      typeof factory === 'function' && factory(function(app, exports){
        setApp(app, exports);
        config.callback[app] = function(){
          factory(setApp);
        }
      });
      return this;
    };

    type && (
      factory = deps,
      deps = []
    );

    that.use(deps, callback, null, 'define');
    return that;
  };

  // 使用特定模块
  Mbui.prototype.use = function(apps, callback, exports, from){
    var that = this;
    var dir = config.dir = config.dir ? config.dir : getPath;
    var head = doc.getElementsByTagName('head')[0];

    apps = function(){
      if(typeof apps === 'string'){
        return [apps];
      }
      // 当第一个参数为 function 时，则自动加载所有内置模块，且执行的回调即为该 function 参数；
      else if(typeof apps === 'function'){
        callback = apps;
        return ['all'];
      }
      return apps;
    }();

    var item = apps[0];
    var timeout = 0;

    exports = exports || [];

    // 静态资源host
    config.host = config.host || (dir.match(/\/\/([\s\S]+?)\//)||['//'+ location.host +'/'])[0];

    // 加载完毕
    function onScriptLoad(e, url){
      var readyRegExp = navigator.platform === 'PLaySTATION 3' ? /^complete$/ : /^(complete|loaded)$/;
      if (e.type === 'load' || (readyRegExp.test((e.currentTarget || e.srcElement).readyState))) {
        config.modules[item] = url;
        head.removeChild(node);
        (function poll() {
          if(++timeout > config.timeout * 1000 / 4){
            return error(item + ' is not a valid module', 'error');
          }
          config.status[item] ? onCallback() : setTimeout(poll, 4);
        }());
      }
    }

    // 回调
    function onCallback(){
      exports.push(mbui[item]);
      apps.length > 1 ?
        that.use(apps.slice(1), callback, exports, from)
      : ( typeof callback === 'function' && function(){
        // 保证文档加载完毕再执行回调
        callback.apply(mbui, exports);
      }() );
    }

    // 如果引入了聚合板，内置的模块则不必重复加载
    if( apps.length === 0 || (modules[item]) ){
      return onCallback(), that;
    }

    /*
     * 获取加载的模块 URL
     * 如果是内置模块，则按照 dir 参数拼接模块路径
     * 如果是扩展模块，则判断模块路径值是否为 {/} 开头，
     * 如果路径值是 {/} 开头，则模块路径即为后面紧跟的字符。
     * 否则，则按照 base 参数拼接模块路径
    */

    var url = ( modules[item] ? (dir + 'modules/')
      : (/^\{\/\}/.test(that.modules[item]) ? '' : (config.base || ''))
    ) + (that.modules[item] || item) + '.js';
    url = url.replace(/^\{\/\}/, '');

    // 如果扩展模块（即：非内置模块）对象已经存在，则不必再加载
    if(!config.modules[item] && mbui[item]){
      config.modules[item] = url; // 并记录起该扩展模块的 url
    }

    // 首次加载模块
    if(!config.modules[item]){
      var node = doc.createElement('script');

      node.async = true;
      node.charset = 'utf-8';
      node.src = url + function(){
        var version = config.version === true ? (config.v || (new Date()).getTime()) : (config.version||'');
        return version ? ('?v=' + version) : '';
      }();

      head.appendChild(node);

      if(node.attachEvent && !(node.attachEvent.toString && node.attachEvent.toString().indexOf('[native code') < 0) && !isOpera){
        node.attachEvent('onreadystatechange', function(e){
          onScriptLoad(e, url);
        });
      } else {
        node.addEventListener('load', function(e){
          onScriptLoad(e, url);
        }, false);
      }

      config.modules[item] = url;
    } else { // 缓存
      (function poll() {
        if(++timeout > config.timeout * 1000 / 4){
          return error(item + ' is not a valid module', 'error');
        }
        (typeof config.modules[item] === 'string' && config.status[item])
        ? onCallback()
        : setTimeout(poll, 4);
      }());
    }

    return that;
  };
  
 // 弃用原有的指定模块，以便重新扩展新的同名模块
  Mbui.prototype.disuse = function(apps){
    var that = this;
    apps = that.isArray(apps) ? apps : [apps];
    that.each(apps, function (index, item) {
      if (!config.status[item]) {
        //
      }
      delete that[item];
      delete modules[item];
      delete that.modules[item];
      delete config.status[item];
      delete config.modules[item];
    });
    return that;
  };

  // 获取节点的 style 属性值
  Mbui.prototype.getStyle = function(node, name){
    var style = node.currentStyle ? node.currentStyle : win.getComputedStyle(node, null);
    return style[style.getPropertyValue ? 'getPropertyValue' : 'getAttribute'](name);
  };

  // css 外部加载器
  Mbui.prototype.link = function(href, fn, cssname){
    var that = this;
    var head = doc.getElementsByTagName('head')[0];
    var link = doc.createElement('link');

    if(typeof fn === 'string') cssname = fn;

    var app = (cssname || href).replace(/\.|\//g, '');
    var id = 'mbuicss-'+ app;
    var STAUTS_NAME = 'creating';
    var timeout = 0;

    link.href = href + (config.debug ? '?v='+new Date().getTime() : '');
    link.rel = 'stylesheet';
    link.id = id;
    link.media = 'all';

    if(!doc.getElementById(id)){
      head.appendChild(link);
    }

    if(typeof fn !== 'function') return that;

    // 轮询 css 是否加载完毕
    (function poll(status) {
      var delay = 100;
      var getLinkElem = doc.getElementById(id); // 获取动态插入的 link 元素

      // 如果轮询超过指定秒数，则视为请求文件失败或 css 文件不符合规范
      if(++timeout > config.timeout * 1000 / delay){
        return error(href + ' timeout');
      }

      // css 加载就绪
      if(parseInt(that.getStyle(getLinkElem, 'width')) === 1989){
        // 如果参数来自于初始轮询（即未加载就绪时的），则移除 link 标签状态
        if(status === STAUTS_NAME) getLinkElem.removeAttribute('load-status');
        // 如果 link 标签的状态仍为「创建中」，则继续进入轮询，直到状态改变，则执行回调
        getLinkElem.getAttribute('load-status') === STAUTS_NAME ? setTimeout(poll, delay) : fn();
      } else {
        getLinkElem.setAttribute('load-status', STAUTS_NAME);
        setTimeout(function(){
          poll(STAUTS_NAME);
        }, delay);
      }
    }());

    return that;
  };

  // css 内部加载器
  Mbui.prototype.addcss = function(firename, fn, cssname){
    return mbui.link(config.dir + 'css/' + firename, fn, cssname);
  };

  // 存储模块的回调
  config.callback = {};

  // 重新执行模块的工厂函数
  Mbui.prototype.factory = function(modName){
    if(mbui[modName]){
      return typeof config.callback[modName] === 'function'
        ? config.callback[modName]
      : null;
    }
  };

  // 全局配置
  Mbui.prototype.config = function(options){
    options = options || {};
    for(var key in options){
      config[key] = options[key];
    }
    return this;
  };

  // 记录全部模块
  Mbui.prototype.modules = function(){
    var clone = {};
    for(var o in modules){
      clone[o] = modules[o];
    }
    return clone;
  }();

  // 拓展模块
  Mbui.prototype.extend = function(options){
    var that = this;

    // 验证模块是否被占用
    options = options || {};
    for(var o in options){
      if(that[o] || that.modules[o]){
        error(o+ ' Module already exists', 'error');
      } else {
        that.modules[o] = options[o];
      }
    }

    return that;
  };

  // location.hash 路由解析
  Mbui.prototype.router = Mbui.prototype.hash = function(hash){
    var that = this;
    var hash = hash || location.hash;
    var data = {
      path: [],
      search: {},
      hash: (hash.match(/[^#](#.*$)/) || [])[1] || ''
    };

    if(!/^#\//.test(hash)) return data; // 禁止非路由规范

    hash = hash.replace(/^#\//, '');
    data.href = '/' + hash;
    hash = hash.replace(/([^#])(#.*$)/, '$1').split('/') || [];

    // 提取 Hash 结构
    that.each(hash, function(index, item){
      /^\w+=/.test(item) ? function(){
        item = item.split('=');
        data.search[item[0]] = item[1];
      }() : data.path.push(item);
    });

    return data;
  };

  // URL 解析
  Mbui.prototype.url = function(href){
    var that = this;
    var data = {
      // 提取 url 路径
      pathname: function(){
        var pathname = href
          ? function(){
            var str = (href.match(/\.[^.]+?\/.+/) || [])[0] || '';
            return str.replace(/^[^\/]+/, '').replace(/\?.+/, '');
          }()
        : location.pathname;
        return pathname.replace(/^\//, '').split('/');
      }(),

      // 提取 url 参数
      search: function(){
        var obj = {};
        var search = (href
          ? function(){
            var str = (href.match(/\?.+/) || [])[0] || '';
            return str.replace(/\#.+/, '');
          }()
          : location.search
        ).replace(/^\?+/, '').split('&'); // 去除 ?，按 & 分割参数

        // 遍历分割后的参数
        that.each(search, function(index, item){
          var _index = item.indexOf('=')
          ,key = function(){ // 提取 key
            if(_index < 0){
              return item.substr(0, item.length);
            } else if(_index === 0){
              return false;
            } else {
              return item.substr(0, _index);
            }
          }();
          // 提取 value
          if(key){
            obj[key] = _index > 0 ? item.substr(_index + 1) : null;
          }
        });

        return obj;
      }(),

      // 提取 Hash
      hash: that.router(function(){
        return href
          ? ((href.match(/#.+/) || [])[0] || '/')
        : location.hash;
      }())
    };

    return data;
  };

  // 遍历
  Mbui.prototype.each = function(obj, fn){
    var key;
    var that = this;
    var callFn = function(key, obj){ // 回调
      return fn.call(obj[key], key, obj[key])
    };

    if(typeof fn !== 'function') return that;
    obj = obj || [];

    // 优先处理数组结构
    if(that.isArray(obj)){
      for(key = 0; key < obj.length; key++){
        if(callFn(key, obj)) break;
      }
    } else {
      for(key in obj){
        if(callFn(key, obj)) break;
      }
    }

    return that;
  };
  // 字符常理
  var EV_REMOVE = 'MOBAI-EVENT-REMOVE';

  // 执行自定义模块事件
  Mbui.prototype.event = Mbui.event = function(modName, events, params, fn){
    var that = this;
    var result = null;
    var filter = (events || '').match(/\((.*)\)$/)||[]; // 提取事件过滤器字符结构，如：select(xxx)
    var eventName = (modName + '.'+ events).replace(filter[0], ''); // 获取事件名称，如：form.select
    var filterName = filter[1] || ''; // 获取过滤器名称,，如：xxx
    var callback = function(_, item){
      var res = item && item.call(that, params);
      res === false && result === null && (result = false);
    };

    // 如果参数传入特定字符，则执行移除事件
    if(params === EV_REMOVE){
      delete (that.cache.event[eventName] || {})[filterName];
      return that;
    }

    // 添加事件
    if(fn){
      config.event[eventName] = config.event[eventName] || {};

      if (filterName) {
        // 带filter不支持重复事件
        config.event[eventName][filterName] = [fn];
      } else {
        // 不带filter处理的是所有的同类事件，应该支持重复事件
        config.event[eventName][filterName] = config.event[eventName][filterName] || [];
        config.event[eventName][filterName].push(fn);
      }
      return this;
    }

    // 执行事件回调
    mbui.each(config.event[eventName], function(key, item){
      // 执行当前模块的全部事件
      if(filterName === '{*}'){
        mbui.each(item, callback);
        return;
      }
      // 执行指定事件
      key === '' && mbui.each(item, callback);
      (filterName && key === filterName) && mbui.each(item, callback);
    });
    return result;
  };
  win.mbui = new Mbui();
}(window);

mbui.define([],function(z){"use strict";var A={countdown:function(h){var j=this;h=$.extend(true,{date:new Date(),now:new Date()},h);var k=arguments;if(k.length>1){h.date=new Date(k[0]);h.now=new Date(k[1]);h.clock=k[2]}var m={options:h,clear:function(){clearTimeout(m.timer)},reload:function(a){this.clear();$.extend(true,this.options,{now:new Date()},a);g()}};typeof h.ready==='function'&&h.ready();var g=(function fn(){var b=new Date(h.date);var c=new Date(h.now);var e=function(a){return a>0?a:0}(b.getTime()-c.getTime());var f={d:Math.floor(e/(1000*60*60*24)),h:Math.floor(e/(1000*60*60))%24,m:Math.floor(e/(1000*60))%60,s:Math.floor(e/1000)%60};var i=function(){c.setTime(c.getTime()+1000);h.now=c;g()};m.timer=setTimeout(i,1000);typeof h.clock==='function'&&h.clock(f,m);if(e<=0){clearTimeout(m.timer);typeof h.done==='function'&&h.done(f,m)}return fn})();return m},timeAgo:function(a,b){var c=this;var e=[[],[]];var f=new Date().getTime()-new Date(a).getTime();if(f>1000*60*60*24*31){f=new Date(a);e[0][0]=c.digit(f.getFullYear(),4);e[0][1]=c.digit(f.getMonth()+1);e[0][2]=c.digit(f.getDate());if(!b){e[1][0]=c.digit(f.getHours());e[1][1]=c.digit(f.getMinutes());e[1][2]=c.digit(f.getSeconds())}return e[0].join('-')+' '+e[1].join(':')}if(f>=1000*60*60*24){return((f/1000/60/60/24)|0)+' 天前'}else if(f>=1000*60*60){return((f/1000/60/60)|0)+' 小时前'}else if(f>=1000*60*3){return((f/1000/60)|0)+' 分钟前'}else if(f<0){return'未来'}else{return'刚刚'}},toDateString:function(e,f,i){if(e===null||e==='')return'';var h=/\[([^\]]+)]|y{1,4}|M{1,2}|d{1,2}|H{1,2}|h{1,2}|a|A|m{1,2}|s{1,2}|SSS/g;var j=this;var k=new Date(function(){if(!e)return;return isNaN(e)?e:(typeof e==='string'?parseInt(e):e)}()||new Date());if(!k.getDate())return console.log('Invalid millisecond for "tool.toDateString(millisecond)"');var m=k.getFullYear();var g=k.getMonth();var n=k.getDate();var l=k.getHours();var o=k.getMinutes();var p=k.getSeconds();var q=k.getMilliseconds();var r=function(a,b){var c=a*100+b;if(c<600){return'凌晨'}else if(c<900){return'早上'}else if(c<1100){return'上午'}else if(c<1300){return'中午'}else if(c<1800){return'下午'}return'晚上'};var v=(i&&i.customMeridiem)||r;var u={yy:function(){return String(m).slice(-2)},yyyy:function(){return j.digit(m,4)},M:function(){return String(g+1)},MM:function(){return j.digit(g+1)},d:function(){return String(n)},dd:function(){return j.digit(n)},H:function(){return String(l)},HH:function(){return j.digit(l)},h:function(){return String(l%12||12)},hh:function(){return j.digit(l%12||12)},A:function(){return v(l,o)},m:function(){return String(o)},mm:function(){return j.digit(o)},s:function(){return String(p)},ss:function(){return j.digit(p)},SSS:function(){return j.digit(q,3)}};f=f||'yyyy-MM-dd HH:mm:ss';return f.replace(h,function(a,b){return b||(u[a]&&u[a]())||a})},time:function(){return Math.floor((new Date).getTime()/1e3)},date:function(e,f){var i,h,j=["Sun","Mon","Tues","Wednes","Thurs","Fri","Satur","January","February","March","April","May","June","July","August","September","October","November","December"],k=/\\?(.?)/gi,m=function(a,b){return h[a]?h[a]():b},g=function(a,b){for(a=String(a);a.length<b;)a="0"+a;return a};h={d:function(){return g(h.j(),2)},D:function(){return h.l().slice(0,3)},j:function(){return i.getDate()},l:function(){return j[h.w()]+"day"},N:function(){return h.w()||7},S:function(){var a=h.j(),b=a%10;return b<=3&&1===parseInt(a%100/10,10)&&(b=0),["st","nd","rd"][b-1]||"th"},w:function(){return i.getDay()},z:function(){var a=new Date(h.Y(),h.n()-1,h.j()),b=new Date(h.Y(),0,1);return Math.round((a-b)/864e5)},W:function(){var a=new Date(h.Y(),h.n()-1,h.j()-h.N()+3),b=new Date(a.getFullYear(),0,4);return g(1+Math.round((a-b)/864e5/7),2)},F:function(){return j[6+h.n()]},m:function(){return g(h.n(),2)},M:function(){return h.F().slice(0,3)},n:function(){return i.getMonth()+1},t:function(){return new Date(h.Y(),h.n(),0).getDate()},L:function(){var a=h.Y();return a%4==0&a%100!=0|a%400==0},o:function(){var a=h.n(),b=h.W();return h.Y()+(12===a&&b<9?1:1===a&&b>9?-1:0)},Y:function(){return i.getFullYear()},y:function(){return h.Y().toString().slice(-2)},a:function(){return i.getHours()>11?"pm":"am"},A:function(){return h.a().toUpperCase()},B:function(){var a=3600*i.getUTCHours(),b=60*i.getUTCMinutes(),c=i.getUTCSeconds();return g(Math.floor((a+b+c+3600)/86.4)%1e3,3)},g:function(){return h.G()%12||12},G:function(){return i.getHours()},h:function(){return g(h.g(),2)},H:function(){return g(h.G(),2)},i:function(){return g(i.getMinutes(),2)},s:function(){return g(i.getSeconds(),2)},u:function(){return g(1e3*i.getMilliseconds(),6)},e:function(){throw new Error("Not supported (see source code of date() for timezone on how to add support)")},I:function(){return new Date(h.Y(),0)-Date.UTC(h.Y(),0)!=new Date(h.Y(),6)-Date.UTC(h.Y(),6)?1:0},O:function(){var a=i.getTimezoneOffset(),b=Math.abs(a);return(a>0?"-":"+")+g(100*Math.floor(b/60)+b%60,4)},P:function(){var a=h.O();return a.substr(0,3)+":"+a.substr(3,2)},T:function(){return"UTC"},Z:function(){return 60*-i.getTimezoneOffset()},c:function(){return"Y-m-d\\TH:i:sP".replace(k,m)},r:function(){return"D, d M Y H:i:s O".replace(k,m)},U:function(){return i/1e3|0}};return function(a,b){return i=void 0===b?new Date:b instanceof Date?new Date(b):new Date(1e3*b),a.replace(k,m)}(e,f)},strtotime:function(j,k){var m,g,n,l,o,p,q,r,v,u,x,s=false;if(!j){return s}j=j.replace(/^\s+|\s+$/g,"").replace(/\s{2,}/g," ").replace(/[\t\r\n]/g,"").toLowerCase();g=j.match(/^(\d{1,4})([\-\.\/\:])(\d{1,2})([\-\.\/\:])(\d{1,4})(?:\s(\d{1,2}):(\d{2})?:?(\d{2})?)?(?:\s([A-Z]+)?)?$/);if(g&&g[2]===g[4]){if(g[1]>1901){switch(g[2]){case"-":if(g[3]>12||g[5]>31){return s}return new Date(g[1],parseInt(g[3],10)-1,g[5],g[6]||0,g[7]||0,g[8]||0,g[9]||0)/1000;case".":return s;case"/":if(g[3]>12||g[5]>31){return s}return new Date(g[1],parseInt(g[3],10)-1,g[5],g[6]||0,g[7]||0,g[8]||0,g[9]||0)/1000}}else{if(g[5]>1901){switch(g[2]){case"-":if(g[3]>12||g[1]>31){return s}return new Date(g[5],parseInt(g[3],10)-1,g[1],g[6]||0,g[7]||0,g[8]||0,g[9]||0)/1000;case".":if(g[3]>12||g[1]>31){return s}return new Date(g[5],parseInt(g[3],10)-1,g[1],g[6]||0,g[7]||0,g[8]||0,g[9]||0)/1000;case"/":if(g[1]>12||g[3]>31){return s}return new Date(g[5],parseInt(g[1],10)-1,g[3],g[6]||0,g[7]||0,g[8]||0,g[9]||0)/1000}}else{switch(g[2]){case"-":if(g[3]>12||g[5]>31||(g[1]<70&&g[1]>38)){return s}l=g[1]>=0&&g[1]<=38?+g[1]+2000:g[1];return new Date(l,parseInt(g[3],10)-1,g[5],g[6]||0,g[7]||0,g[8]||0,g[9]||0)/1000;case".":if(g[5]>=70){if(g[3]>12||g[1]>31){return s}return new Date(g[5],parseInt(g[3],10)-1,g[1],g[6]||0,g[7]||0,g[8]||0,g[9]||0)/1000}if(g[5]<60&&!g[6]){if(g[1]>23||g[3]>59){return s}n=new Date();return new Date(n.getFullYear(),n.getMonth(),n.getDate(),g[1]||0,g[3]||0,g[5]||0,g[9]||0)/1000}return s;case"/":if(g[1]>12||g[3]>31||(g[5]<70&&g[5]>38)){return s}l=g[5]>=0&&g[5]<=38?+g[5]+2000:g[5];return new Date(l,parseInt(g[1],10)-1,g[3],g[6]||0,g[7]||0,g[8]||0,g[9]||0)/1000;case":":if(g[1]>23||g[3]>59||g[5]>59){return s}n=new Date();return new Date(n.getFullYear(),n.getMonth(),n.getDate(),g[1]||0,g[3]||0,g[5]||0)/1000}}}}if(j==="now"){return k===null||isNaN(k)?new Date().getTime()/1000|0:k|0}if(!isNaN(m=Date.parse(j))){return m/1000|0}o=k?new Date(k*1000):new Date();p={"sun":0,"mon":1,"tue":2,"wed":3,"thu":4,"fri":5,"sat":6};q={"yea":"FullYear","mon":"Month","day":"Date","hou":"Hours","min":"Minutes","sec":"Seconds"};function t(a,b,c){var e,f=p[b];if(typeof f!=="undefined"){e=f-o.getDay();if(e===0){e=7*c}else{if(e>0&&a==="last"){e-=7}else{if(e<0&&a==="next"){e+=7}}}o.setDate(o.getDate()+e)}}function y(a){var b=a.split(" "),c=b[0],e=b[1].substring(0,3),f=/\d+/.test(c),i=b[2]==="ago",h=(c==="last"?-1:1)*(i?-1:1);if(f){h*=parseInt(c,10)}if(q.hasOwnProperty(e)&&!b[1].match(/^mon(day|\.)?$/i)){return o["set"+q[e]](o["get"+q[e]]()+h)}if(e==="wee"){return o.setDate(o.getDate()+(h*7))}if(c==="next"||c==="last"){t(c,e,h)}else{if(!f){return false}}return true}v="(years?|months?|weeks?|days?|hours?|minutes?|min|seconds?|sec|sunday|sun\\.?|monday|mon\\.?|tuesday|tue\\.?|wednesday|wed\\.?|thursday|thu\\.?|friday|fri\\.?|saturday|sat\\.?)";u="([+-]?\\d+\\s"+v+"|(last|next)\\s"+v+")(\\sago)?";g=j.match(new RegExp(u,"gi"));if(!g){return s}for(x=0,r=g.length;x<r;x++){if(!y(g[x])){return s}}return(o.getTime()/1000)},date_eq:function(a,b){var c=new Date(a.replace(/\-/g,"\/"));var e=new Date(b.replace(/\-/g,"\/"));if((c-e)>=0){return true}else{return false}},timeline:function(a){var b=new Date();var c=new Date(a*1000);var e=b.getTime()-c.getTime();if(e<=0){e=1000}if(e<60*1000){return Math.floor(e/1000)+"秒前"}else{if(e<60*60*1000){return Math.floor(e/(1000*60))+"分钟前"}else{if(e<60*60*1000*24){return Math.floor(e/(1000*60*60))+"小时前"}else{if(e<60*60*1000*24*7){return Math.floor(e/(1000*60*60*24))+"天前"}else{if(e<60*60*1000*24*7*56){return Math.floor(e/(1000*60*60*24*7))+"周前"}else{return Math.floor(e/(1000*60*60*24*7*52))+"年前"}}}}}},getFirstNowLastDay:function(a){var b=a?new Date(a):new Date();var c="-";var e=b.getFullYear();var f=b.getMonth()+1;var i=b.getDate();if(f>=1&&f<=9){f="0"+f}if(i>=1&&i<=9){i="0"+i}var h=e+c+f;var j=e+c+f+c+'01';var k=e+c+f+c+i;var m=this.getLastDay(e,f);var g=e+c+f+c+m;return[j,k,g,h]},getLastDay:function(a,b){var c=a;var e=b++;if(b>12){e-=12;c++}return new Date(c,e,0).getDate()},array_keys:function(a,b,c){var e=void 0!==b,f=[],i=!!c,h=!0,j="";for(j in a)a.hasOwnProperty(j)&&(h=!0,e&&(i&&a[j]!==b?h=!1:a[j]!==b&&(h=!1)),h&&(f[f.length]=j));return f},array_values:function(a){var b=[],c="";for(c in a)b[b.length]=a[c];return b},array_unique:function(e){var f="",i={},h="";for(f in e)e.hasOwnProperty(f)&&(h=e[f],!1===function(a,b){var c="";for(c in b)if(b.hasOwnProperty(c)&&b[c]+""==a+"")return c;return!1}(h,i)&&(i[f]=h));return i},array_slice:function(a,b,c,e){var f="";if("[object Array]"!==Object.prototype.toString.call(a)||e&&0!==b){var i=0,h={};for(f in a)i+=1,h[f]=a[f];a=h,b=b<0?i+b:b,c=void 0===c?i:c<0?i+c-b:c;var j={},k=!1,m=-1,g=0,n=0;for(f in a){if(++m,g>=c)break;m===b&&(k=!0),k&&(++g,is_int(f)&&!e?j[n++]=a[f]:j[f]=a[f])}return j}return void 0===c?a.slice(b):c>=0?a.slice(b,b+c):a.slice(b,c)},array_search:function(a,b,c){var e=!!c,f="";if("object"==typeof a&&a.exec){if(!e){var i="i"+(a.global?"g":"")+(a.multiline?"m":"")+(a.sticky?"y":"");a=new RegExp(a.source,i)}for(f in b)if(b.hasOwnProperty(f)&&a.test(b[f]))return f;return!1}for(f in b)if(b.hasOwnProperty(f)&&(e&&b[f]===a||!e&&b[f]==a))return f;return!1},is_array:function(c){if(!c||"object"!=typeof c)return!1;if(function(c){if(!c||"object"!=typeof c||"number"!=typeof c.length)return!1;var e=c.length;return c[c.length]="bogus",e!==c.length?(c.length-=1,!0):(delete c[c.length],!1)}(c))return!0;var e=Object.prototype.toString.call(c),f=function(a){var b=/\W*function\s+([\w$]+)\s*\(/.exec(a);return b?b[1]:"(Anonymous)"}(c.constructor);return"[object Object]"===e&&"Object"===f},in_array:function(a,b,c){var e="";if(!c){for(e in b)if(b[e]==a)return!0}else for(e in b)if(b[e]===a)return!0;return!1},sort:function(h,j,k=m){var g=[],n=[],l='',o=0,p=false,q=[];switch(j){case'SORT_STRING':p=function(a,b){return strnatcmp(a,b)};break;case'SORT_NUMERIC':p=function(a,b){return(a-b)};break;default:p=function(a,b){var c=parseFloat(a),e=parseFloat(b),f=c+''===a,i=e+''===b;if(f&&i){return c>e?1:c<e?-1:0}else if(f&&!i){return 1}else if(!f&&i){return-1}return a>b?1:a<b?-1:0};break}q=k?h:q;for(l in h){if(h.hasOwnProperty(l)){g.push(h[l]);if(k){delete h[l]}}}g.sort(p);for(o=0;o<g.length;o++){q[o]=g[o]}return k||q},is_int:function(a){return a===+a&&isFinite(a)&&!(a%1)},is_float:function(a){return!(+a!==a||isFinite(a)&&!(a%1))},is_object:function(a){return"[object Array]"!==Object.prototype.toString.call(a)&&(null!==a&&"object"==typeof a)},function_exists:function(a){var b="undefined"!=typeof window?window:global;return"string"==typeof a&&(a=b[a]),"function"==typeof a},serialize:function(h){var j,k,m,g="",n=0,l=function(a){var b,c,e,f,i=typeof a;if("object"===i&&!a)return"null";if("object"===i){if(!a.constructor)return"object";e=a.constructor.toString(),b=e.match(/(\w+)\(/),b&&(e=b[1].toLowerCase()),f=["boolean","number","string","array"];for(c in f)if(e==f[c]){i=f[c];break}}return i},o=l(h);switch(o){case"function":j="";break;case"boolean":j="b:"+(h?"1":"0");break;case"number":j=(Math.round(h)==h?"i":"d")+":"+h;break;case"string":j="s:"+function(a){var b=0,c=0,e=a.length,f="";for(c=0;c<e;c++)f=a.charCodeAt(c),b+=f<128?1:f<2048?2:3;return b}(h)+':"'+h+'"';break;case"array":case"object":j="a";for(k in h)if(h.hasOwnProperty(k)){if("function"===l(h[k]))continue;m=k.match(/^[0-9]+$/)?parseInt(k,10):k,g+=this.serialize(m)+this.serialize(h[k]),n++}j+=":"+n+":{"+g+"}";break;case"undefined":default:j="N"}return"object"!==o&&"array"!==o&&(j+=";"),j},unserialize:function(B){var C=this,D=function(a){var b=a.charCodeAt(0);return b<128?0:b<2048?1:2};return error=function(a,b,c,e){throw new C.window[a](b,c,e)},read_until=function(a,b,c){for(var e=2,f=[],i=a.slice(b,b+1);i!=c;)e+b>a.length&&error("Error","Invalid"),f.push(i),i=a.slice(b+(e-1),b+e),e+=1;return[f.length,f.join("")]},read_chrs=function(a,b,c){var e,f,i;for(i=[],e=0;e<c;e++)f=a.slice(b+(e-1),b+e),i.push(f),c-=D(f);return[i.length,i.join("")]},_unserialize=function(b,c){var e,f,i,h,j,k,m,g,n,l,o,p,q,r,v,u,x,s,t=0,y=function(a){return a};switch(c||(c=0),e=b.slice(c,c+1).toLowerCase(),f=c+2,e){case"i":y=function(a){return parseInt(a,10)},n=read_until(b,f,";"),t=n[0],g=n[1],f+=t+1;break;case"b":y=function(a){return 0!==parseInt(a,10)},n=read_until(b,f,";"),t=n[0],g=n[1],f+=t+1;break;case"d":y=function(a){return parseFloat(a)},n=read_until(b,f,";"),t=n[0],g=n[1],f+=t+1;break;case"n":g=null;break;case"s":l=read_until(b,f,":"),t=l[0],o=l[1],f+=t+2,n=read_chrs(b,f+1,parseInt(o,10)),t=n[0],g=n[1],f+=t+2,t!=parseInt(o,10)&&t!=g.length&&error("SyntaxError","String length mismatch");break;case"a":for(g={},i=read_until(b,f,":"),t=i[0],h=i[1],f+=t+2,k=parseInt(h,10),j=!0,p=0;p<k;p++)r=_unserialize(b,f),v=r[1],q=r[2],f+=v,u=_unserialize(b,f),x=u[1],s=u[2],f+=x,q!==p&&(j=!1),g[q]=s;if(j){for(m=new Array(k),p=0;p<k;p++)m[p]=g[p];g=m}f+=1;break;default:error("SyntaxError","Unknown / Unhandled data type(s): "+e)}return[e,f-c,y(g)]},_unserialize(B+"",0)[2]},uniqid:function(c,e){void 0===c&&(c="");var f,i=function(a,b){return a=parseInt(a,10).toString(16),b<a.length?a.slice(a.length-b):b>a.length?Array(b-a.length+1).join("0")+a:a},h="undefined"!=typeof window?window:global;h.$locutus=h.$locutus||{};var j=h.$locutus;return j.php=j.php||{},j.php.uniqidSeed||(j.php.uniqidSeed=Math.floor(123456789*Math.random())),j.php.uniqidSeed++,f=c,f+=i(parseInt((new Date).getTime()/1e3,10),8),f+=i(j.php.uniqidSeed,5),e&&(f+=(10*Math.random()).toFixed(8).toString()),f},intval:function(a,b){var c,e,f=typeof a;return"boolean"===f?+a:"string"===f?(0===b&&(e=a.match(/^\s*0(x?)/i),b=e?e[1]?16:8:10),c=parseInt(a,b||10),isNaN(c)||!isFinite(c)?0:c):"number"===f&&isFinite(a)?a<0?Math.ceil(a):Math.floor(a):0},floatval:function(a){return parseFloat(a)||0},log:function(a){console.log(a)},trim:function(a,b){var c=[" ","\n","\r","\t","\f","\v"," "," "," "," "," "," "," "," "," "," "," "," ","​","\u2028","\u2029","　"].join(""),e=0,f=0;for(a+="",b&&(c=(b+"").replace(/([[\]().?\/*{}+$^:])/g,"$1")),e=a.length,f=0;f<e;f++)if(-1===c.indexOf(a.charAt(f))){a=a.substring(f);break}for(e=a.length,f=e-1;f>=0;f--)if(-1===c.indexOf(a.charAt(f))){a=a.substring(0,f+1);break}return-1===c.indexOf(a.charAt(0))?a:""},rtrim:function(a,b){return b=b?(b+"").replace(/([[\]().?\/*{}+$^:])/g,"\\$1"):" \\s ",(a+"").replace(new RegExp("["+b+"]+$","g"),"")},ltrim:function(a,b){return b=b?(b+"").replace(/([[\]().?\/*{}+$^:])/g,"$1"):" \\s ",(a+"").replace(new RegExp("^["+b+"]+","g"),"")},strtrim:function(a){return a.replace(/\s+/g," ")},str_replace:function(a,b,c,e){var f=0,i=0,h="",j="",k=0,m=0,g=[].concat(a),n=[].concat(b),l=c,o="[object Array]"===Object.prototype.toString.call(n),p="[object Array]"===Object.prototype.toString.call(l);l=[].concat(l);var q="undefined"!=typeof window?window:global;q.$locutus=q.$locutus||{};var r=q.$locutus;if(r.php=r.php||{},"object"==typeof a&&"string"==typeof b){for(h=b,b=[],f=0;f<a.length;f+=1)b[f]=h;h="",n=[].concat(b),o="[object Array]"===Object.prototype.toString.call(n)}for(void 0!==e&&(e.value=0),f=0,k=l.length;f<k;f++)if(""!==l[f])for(i=0,m=g.length;i<m;i++)h=l[f]+"",j=o?void 0!==n[i]?n[i]:"":n[0],l[f]=h.split(g[i]).join(j),void 0!==e&&(e.value+=h.split(g[i]).length-1);return p?l:l[0]},strip_tags:function(c,e){e=(((e||"")+"").toLowerCase().match(/<[a-z][a-z0-9]*>/g)||[]).join("");var f=/<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,i=/<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;return c.replace(i,"").replace(f,function(a,b){return e.indexOf("<"+b.toLowerCase()+">")>-1?a:""})},ucfirst:function(a){return a+="",a.charAt(0).toUpperCase()+a.substr(1)},htmlencode:function(k){var m=function(a,b,c,e){var f=0,i=0,h=!1;("undefined"==typeof b||null===b)&&(b=2),a=a.toString(),e!==!1&&(a=a.replace(/&/g,"&amp;")),a=a.replace(/</g,"&lt;").replace(/>/g,"&gt;");var j={ENT_NOQUOTES:0,ENT_HTML_QUOTE_SINGLE:1,ENT_HTML_QUOTE_DOUBLE:2,ENT_COMPAT:2,ENT_QUOTES:3,ENT_IGNORE:4};if(0===b&&(h=!0),"number"!=typeof b){for(b=[].concat(b),i=0;i<b.length;i++)0===j[b[i]]?h=!0:j[b[i]]&&(f|=j[b[i]]);b=f}return b&j.ENT_HTML_QUOTE_SINGLE&&(a=a.replace(/'/g,"&#039;")),h||(a=a.replace(/"/g,"&quot;")),a};return m(k)},htmldecode:function(h){var j=function(a,b){var c=0,e=0,f=!1;"undefined"==typeof b&&(b=2),a=a.toString().replace(/&lt;/g,"<").replace(/&gt;/g,">");var i={ENT_NOQUOTES:0,ENT_HTML_QUOTE_SINGLE:1,ENT_HTML_QUOTE_DOUBLE:2,ENT_COMPAT:2,ENT_QUOTES:3,ENT_IGNORE:4};if(0===b&&(f=!0),"number"!=typeof b){for(b=[].concat(b),e=0;e<b.length;e++)0===i[b[e]]?f=!0:i[b[e]]&&(c|=i[b[e]]);b=c}return b&i.ENT_HTML_QUOTE_SINGLE&&(a=a.replace(/&#0*39;/g,"'")),f||(a=a.replace(/&quot;/g,'"')),a=a.replace(/&amp;/g,"&")};return j(h)},escape:function(a){var b=/[<"'>]|&(?=#[a-zA-Z0-9]+)/g;if(a===undefined||a===null)return'';a+='';if(!b.test(a))return a;return a.replace(/&(?!#?[a-zA-Z0-9]+;)/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/'/g,'&#39;').replace(/"/g,'&quot;')},unescape:function(a){if(a===undefined||a===null)a='';a+='';return a.replace(/\&amp;/g,'&').replace(/\&lt;/g,'<').replace(/\&gt;/g,'>').replace(/\&#39;/g,'\'').replace(/\&quot;/g,'"')},base64_decode:function(c){var e=function(b){return decodeURIComponent(b.split("").map(function(a){return"%"+("00"+a.charCodeAt(0).toString(16)).slice(-2)}).join(""))};if("undefined"==typeof window)return new Buffer(c,"base64").toString("utf-8");if(void 0!==window.atob)return e(window.atob(c));var f,i,h,j,k,m,g,n,l="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",o=0,p=0,q="",r=[];if(!c)return c;c+="";do{j=l.indexOf(c.charAt(o++)),k=l.indexOf(c.charAt(o++)),m=l.indexOf(c.charAt(o++)),g=l.indexOf(c.charAt(o++)),n=j<<18|k<<12|m<<6|g,f=n>>16&255,i=n>>8&255,h=255&n,r[p++]=64===m?String.fromCharCode(f):64===g?String.fromCharCode(f,i):String.fromCharCode(f,i,h)}while(o<c.length);return q=r.join(""),e(q.replace(/\0+$/,""))},base64_encode:function(e){var f=function(c){return encodeURIComponent(c).replace(/%([0-9A-F]{2})/g,function(a,b){return String.fromCharCode("0x"+b)})};if("undefined"==typeof window)return new Buffer(e).toString("base64");if(void 0!==window.btoa)return window.btoa(f(e));var i,h,j,k,m,g,n,l,o="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",p=0,q=0,r="",v=[];if(!e)return e;e=f(e);do{i=e.charCodeAt(p++),h=e.charCodeAt(p++),j=e.charCodeAt(p++),l=i<<16|h<<8|j,k=l>>18&63,m=l>>12&63,g=l>>6&63,n=63&l,v[q++]=o.charAt(k)+o.charAt(m)+o.charAt(g)+o.charAt(n)}while(p<e.length);r=v.join("");var u=e.length%3;return(u?r.slice(0,u-3):r)+"===".slice(u||3)},urlencode:function(a){return a+="",encodeURIComponent(a).replace(/!/g,"%21").replace(/'/g,"%27").replace(/\(/g,"%28").replace(/\)/g,"%29").replace(/\*/g,"%2A").replace(/~/g,"%7E").replace(/%20/g,"+")},urldecode:function(a){return decodeURIComponent((a+"").replace(/%(?![\da-f]{2})/gi,function(){return"%25"}).replace(/\+/g,"%20"))},unicode_decode:function(a){return a=a.replace(/\\/g,"%"),unescape(a)},unicode_encode:function(e){if(1==(arguments.length>1&&void 0!==arguments[1]&&arguments[1])){for(var f=[],i=0;i<e.length;i++)f[i]=("00"+e.charCodeAt(i).toString(16)).slice(-4);return"\\u"+f.join("\\u")}var h=function(a){for(var b=[],c=0;c<a.length;c++)b[c]=("00"+a.charCodeAt(c).toString(16)).slice(-4);return"\\u"+b.join("\\u")},j=/[\ud800-\udbff][\udc00-\udfff]/g;return e=e.replace(j,function(a){return 2===a.length?h(a):a})},get_params:function(a){var b=a+"=",c=window.location.href,e=c.indexOf("?"),c=c.slice(e+1),f=c.split("&"),i=0,h="",j=f.length;for(i=0;i<j;i++){var h=f[i];if(h.indexOf(b)===0){return decodeURIComponent(h.slice(b.length).replace(/\+/g,"%20"))}}return null},mt_rand:function(a,b){var c=arguments.length;if(0===c)a=0,b=2147483647;else{if(1===c)throw new Error("Warning: mt_rand() expects exactly 2 parameters, 1 given");a=parseInt(a,10),b=parseInt(b,10)}return Math.floor(Math.random()*(b-a+1))+a},rand:function(a,b){var c=arguments.length;if(0===c)a=0,b=2147483647;else if(1===c)throw new Error("Warning: rand() expects exactly 2 parameters, 1 given");return Math.floor(Math.random()*(b-a+1))+a},strcut:function(a,b,c){if(isNaN(b)){return a}if(strlen(a)<=b){return a}var e=0,f=0;for(;e<a.length&&f<b;++e,++f){if(a.charCodeAt(e)>255){++f}}c=c||"";return(f-b==1?a.substr(0,e-1):a.substr(0,e))+c},strfind:function(a,b){return!(a.indexOf(b)===-1)},is_num:function(a){var b=new RegExp("^[0-9]*$");return b.test(a)},is_mobile:function(a){var b=/^1\d{10}$/;return b.test(a)},is_qq:function(a){var b=/^[1-utf8_decode]{1}\d{4,11}$/;return b.test(a)},is_email:function(a){var b=/^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;return b.test(a)},is_chinese:function(a){var b=/[\u4e00-\u9fa5]/g;return b.test(a)},is_reg:function(a){var b=/^([a-zA-z_]{1})([\w]*)$/g;return b.test(a)},is_tel:function(a){var b=/^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/;return b.test(a)},is_ip:function(a){if(isNull(a)){return false}var b=/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/g;if(b.test(a)){if(RegExp.$1<256&&RegExp.$2<256&&RegExp.$3<256&&RegExp.$4<256){return true}}return false},is_zipcode:function(a){var b=/^(\d){6}$/;return b.test(a)},is_english:function(a){var b=/^[A-Za-z]+$/;return b.test(a)},is_url:function(a){var b=/(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?/;var c=new RegExp(b);return c.test(a)},is_http:function(a){if(a.indexOf("http://")===-1&&a.indexOf("https://")===-1){return false}return true},is_money:function(a){return!!/(^[1-9]([0-9]+)?(\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\.[0-9]([0-9])?$)/.test(a)},is_CardNumber:function(a){return a.toString().replace(/\s/g,'').replace(/(.{4})/g,"$1 ")},is_IDCard:function(a){var b=[7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2];var c=['1','0','X','9','8','7','6','5','4','3','2','x'];var e=a+"";var f=a[17];var i=e.substring(0,17);var h=i.split("");var j=h.length;var k=0;for(var m=0;m<j;m++){k=k+h[m]*b[m]}var g=k%11;var n=c[g];var l=/^(^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$)|(^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])((\d{4})|\d{3}[Xx])$)$/;var o=l.test(a);return f===n&&o},in_int:function(a,b,c){if(!isFinite(a)){return false}if(!/^[+-]?\d+$/.test(a)){return false}if(b!=undefined&&parseInt(a)<parseInt(b)){return false}if(c!=undefined&&parseInt(a)>parseInt(c)){return false}return true},in_float:function(a,b,c){if(!isFinite(a)){return false}if(b!=undefined&&parseFloat(a)<parseFloat(b)){return false}if(c!=undefined&&parseFloat(a)>parseFloat(c)){return false}return true},number_format:function(f,i,h,j){f=(f+"").replace(/[^0-9+\-Ee.]/g,"");var k=isFinite(+f)?+f:0,m=isFinite(+i)?Math.abs(i):0,g=void 0===j?",":j,n=void 0===h?".":h,l="";return l=(m?function(a,b){if(-1===(""+a).indexOf("e"))return+(Math.round(a+"e+"+b)+"e-"+b);var c=(""+a).split("e"),e="";return+c[1]+b>0&&(e="+"),(+(Math.round(+c[0]+"e"+e+(+c[1]+b))+"e-"+b)).toFixed(b)}(k,m).toString():""+Math.round(k)).split("."),l[0].length>3&&(l[0]=l[0].replace(/\B(?=(?:\d{3})+(?!\d))/g,g)),(l[1]||"").length<m&&(l[1]=l[1]||"",l[1]+=new Array(m-l[1].length+1).join("0")),l.join(n)},digit:function(a,b){var c='';a=String(a);b=b||2;for(var e=a.length;e<b;e++){c+='0'}return a<Math.pow(10,b)?c+(a|0):a},upDigit:function(a,b=c){var e=['角','分','厘'];var f=['零','壹','贰','叁','肆','伍','陆','柒','捌','玖'];var i=[['元','万','亿'],['','拾','佰','仟']];var h=a<0?'欠人民币':'人民币';a=Math.abs(a);var j='',k;for(k=0;k<e.length;k++){j+=(f[Math.floor(a*10*Math.pow(10,k))%10]+e[k]).replace(/零./,'')}j=j||'整';a=Math.floor(a);for(k=0;k<i[0].length&&a>0;k++){var m='';for(var g=0;g<i[1].length&&a>0;g++){m=f[a%10]+i[1][g]+m;a=Math.floor(a/10)}j=m.replace(/(零.)*零$/,'').replace(/^$/,'零')+i[0][k]+j}if(b==true){return h+j.replace(/(零.)*零元/,'元').replace(/(零.)+/g,'零').replace(/^整$/,'零元整')}else{return j.replace(/(零.)*零元/,'元').replace(/(零.)+/g,'零').replace(/^整$/,'零元整')}},hidebank:function(a="6217995510035399947"){return a.replace(/^(\d{8})\d+(\d{4})$/,"$1*******$2")},hidemobile:function(a="18291447788"){return a.replace(/^(\d{3})\d+(\d{4})$/,"$1****$2")},addcss:function(a){var b=document.createElement("style"),c=document.head||document.getElementsByTagName("head")[0];if(b.type="text/css",b.styleSheet){var e=function(){try{b.styleSheet.cssText=a}catch(a){}};b.styleSheet.disabled?setTimeout(e,10):e()}else{var f=document.createTextNode(a);b.appendChild(f)}c.appendChild(b)},addjs:function(a){var b=document.createElement("script");b.type="text/javascript";try{b.appendChild(document.createTextNode(a))}catch(d){b.text=a}document.head.appendChild(b)},loadjs:function(b,c){var e=document.createElement("script");e.src=b,e.onload=function(){var a=e.readyState&&"complete"!=e.readyState&&"loaded"!=e.readyState;c&&c(!a)},document.head.appendChild(e)},loadcss:function(a,b){var c=document.createElement("link");c.rel="stylesheet",c.type="text/css",c.onerror=function(){b(!1)},c.onload=function(){b(!0)},c.href=a,document.head.appendChild(c)},gethost:function(){return window.location.protocol+"//"+window.location.host},distance:function(a,b){var c=a.lat*Math.PI/180.0;var e=b.lat*Math.PI/180.0;var f=c-e;var i=a.lng*Math.PI/180.0-b.lng*Math.PI/180.0;var h=2*Math.asin(Math.sqrt(Math.pow(Math.sin(f/2),2)+Math.cos(c)*Math.cos(e)*Math.pow(Math.sin(i/2),2)));h=h*6378.137;h=Math.round(h*10000)/10000;return h.toFixed(2)},setCookie:function(a,b,c){var e=new Date();e.setDate(e.getDate()+c);document.cookie=a+'='+b+';expires='+e},getCookie:function(a){var b=document.cookie.split('; ');for(var c=0;c<b.length;c++){var e=b[c].split('=');if(e[0]==a){return e[1]}}return''},removeCookie:function(a){this.setCookie(a,1,-1)},computeProgres:function(a,b){var c=parseFloat(a)||0.00,e=parseFloat(b)||0.00;return Math.round(c/e*10000)/100},token:function(a){a=a||32;var b='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';var c='';for(var e=0;e<a;e++){c+=b.charAt(Math.floor(Math.random()*b.length))}return c}};z('tool',A)});

//加载
window.rootPath = (function (src) {
  src = document.currentScript ? document.currentScript.src : document.scripts[document.scripts.length - 1].src;
  let src_array = src.split('?v=');
  if(src_array.length==2){
	  window.webVersion = src_array[1];
  }
  return src.substring(0, src.lastIndexOf("/") + 1);
})();
if (typeof jQuery === "undefined") {
	console.error('请引入jQuery')
}
if (typeof moduleInit == "undefined") {
	window.moduleInit = [];
}
mbui.config({
	base: rootPath + "module/",
	version: window.webVersion?window.webVersion:'58'
}).use(moduleInit, function () {
	if (typeof mbuiInit === 'function') {
		mbuiInit();
	}
});


