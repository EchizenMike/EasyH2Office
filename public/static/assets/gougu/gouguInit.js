window.rootPath = (function (src) {
	src = document.currentScript
		? document.currentScript.src
		: document.scripts[document.scripts.length - 1].src;
	return src.substring(0, src.lastIndexOf("/") + 1);
})();

window.rootVersion = (function (src) {
	src = document.currentScript
		? document.currentScript.src
		: document.scripts[document.scripts.length - 1].src;
	return src.split('?v=')[1];
})();

if (typeof $ == "undefined") {
	window.jQuery = layui.jquery;
	window.$ = layui.jquery;
}
if (typeof moduleInit == "undefined") {
	window.moduleInit = [];
}
var module = {};
if (moduleInit.length > 0) {
	for (var i = 0; i < moduleInit.length; i++) {
		module[moduleInit[i]] = moduleInit[i];
	}
}
layui.config({
	base: rootPath + "module/",
	version: rootVersion
}).extend(module).use(moduleInit, function () {
	if (typeof gouguInit === 'function') {
		gouguInit();
	}
});

//最外层定义好了Picker
window.openGlobalPicker = function(settings) {
    let pickerIndex = new Date().getTime();
    let pickerTable;
    let btn = ['确定选择'];
    if (settings.btnno == true) {
        btn = ['确定选择', '清空已选'];
    }
    if (settings.add != '') {
        btn = ['确定选择', '清空已选', '新增'];
    }

    layer.open({
        title: settings.title,
        area: settings.area,
        type: 1,
        skin: 'gougu-picker',
        content: '<div class="picker-table" id="pickerBox'+pickerIndex+'">'+settings.searchbar+'<div id="pickerTable'+pickerIndex+'"></div></div>',
        success: function () {
            let cols = JSON.parse(JSON.stringify(settings.cols));
            if (settings.type == 1) {
                cols.splice(0, 0, {type: 'radio', title: '选择'});
            }
            if (settings.type == 2) {
                cols.splice(0, 0, {type: 'checkbox', title: '选择'});
            }

            layui.use(['table', 'form'], function () {
                const table = layui.table;
                const form = layui.form;

                pickerTable = table.render({
                    elem: '#pickerTable'+pickerIndex,
                    url: settings.url,
                    where: settings.where,
                    page: settings.page,
                    limit: 10,
                    height: '407',
                    cols: [cols]
                });

                form.on('submit(picker)', function (data) {
                    let maps = $.extend({}, settings.where, data.field);
                    pickerTable.reload({where: maps, page: {curr: 1}});
                    return false;
                });

                $('#pickerBox'+pickerIndex).on('click', '[lay-filter="picker-reset"]', function () {
                    let prev = $(this).prev();
                    if (typeof(prev) != "undefined") {
                        setTimeout(function () {
                            prev.click();
                        }, 10);
                    }
                });
            });
        },
        btn: btn,
        btnAlign: 'c',
        btn1: function (idx) {
            const checkStatus = layui.table.checkStatus(pickerTable.config.id);
            const data = checkStatus.data;
            if (data.length > 0) {
                settings.callback(data);
                layer.close(idx);
            } else {
                layer.msg('请先选择内容');
                return false;
            }
        },
        btn2: function (idx) {
            settings.callback([{'id': 0, 'title': '', 'name': ''}]);
            layer.close(idx);
        },
        btn3: function (idx) {
            if (typeof tool !== 'undefined') {
                tool.side(settings.add);
            }
            layer.close(idx);
        }
    });
};
