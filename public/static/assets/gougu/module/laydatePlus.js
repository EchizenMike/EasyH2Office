layui.define(['layer'],function(exports){
	//提示：模块也可以依赖其它模块，如：layui.define('layer', callback);
	let layer = layui.layer,laydate = layui.laydate, form = layui.form, dropdown = layui.dropdown;
    //输出时间样式为 yyyy-mm-dd hh:mm:ss,不满 2 位则前面添 0；
    function add0(m) {
		return m < 10 ? '0' + m : m
    };
    //获取某月天数 
    function getMonthDays(year, month) {
		var new_year = year,nextMonth = month++;
		if (month > 12) {
			nextMonth -= 12; //月份减
			new_year++; //年份增
		}
		var nextMonthFirstDay = new Date(new_year, nextMonth, 1);
		//下个月第一天
		var oneDay = 1000 * 60 * 60 * 24;
		var dateString = new Date(nextMonthFirstDay - oneDay);
		var dateTime = dateString.getDate();
		return dateTime;
    };
	
    function getPriorMonthFirstDay(year, month) {
		//年份为0代表,是本年的第一月,所以不能减
		if (month == 0) {
			month = 11; //月份为上年的最后月份
			year--; //年份减1
			return new Date(year, month, 1);
		}
		//否则,只减去月份
		month--;
		return new Date(year, month, 1);
    };
	
	const opts={
		"target":'laydateplus',
		"callback": null
	};
	var laydatePlus = function(options){
		this.settings = $.extend({}, opts, options);
		let me = this;
		$('#'+this.settings.target).click(function(){
			me.init();
		});
	};    
	laydatePlus.prototype = {		
		init: function () {
			var me = this;
			var data = [
				{'id':1,'title':'今天'},
				{'id':2,'title':'昨天'},
				{'id':3,'title':'最近7天'},
				{'id':4,'title':'最近30天'},
				{'id':5,'title':'本周'},
				{'id':6,'title':'上周'},
				{'id':7,'title':'本月'},
				{'id':8,'title':'上月'},
				{'id':100,'title':'自定义'},
			];
			dropdown.render({
				elem: '#'+this.settings.target,
				show: true,
				data: data,
				click: function (data, othis) {
					me.select(data.id);
				}
			});
		},
		select:function(select_type){
			let me = this;
			let res=[];
			//快速选择触发事件
			switch (select_type) {
				default:
				laydate.render({
					elem: '#'+this.settings.target,
					type: 'datetime',
					range: '~',
					trigger: 'none',
					show:true
				});
				case 1:
					res = me.getTodayDate();
					break;
				case 2:
					res = me.getYesterdayDate();
					break;
				case 3:
					res = me.getLastSevenDate();
					break;
				case 4:
					res = me.getLastThirtyDate();
					break;
				case 5:
					res = me.getCurrentWeek();
					break;
				case 6:
					res = me.getLastWeek();
					break;
				case 7:
					res = me.getCurrentMonth();
					break;
				case 8:
					res = me.getLastMonth();
					break;
			}
			if(res.length>0){
				$('#'+this.settings.target).val(res.join(' ~ '));
			}
		},
		//获取当天开始时间结束时间
		getTodayDate: function () {
			var today = [];
			var todayDate = new Date();
			var y = todayDate.getFullYear();
			var m = todayDate.getMonth() + 1;
			var d = todayDate.getDate();
			var s = y + '-' + add0(m) + '-' + add0(d) + ' 00:00:00';//今日开始
			var e = y + '-' + add0(m) + '-' + add0(d) + ' 23:59:59';//今日结束
			return {'start':s,'end':e};
		},
		//获取昨天时间
		getYesterdayDate: function () {
			var dateTime = [];
			var today = new Date();
			var yesterday = new Date(today.setTime(today.getTime() - 24 * 60 * 60 * 1000));
			var y = yesterday.getFullYear();
			var m = yesterday.getMonth() + 1;
			var d = yesterday.getDate();
			var s = y + '-' + add0(m) + '-' + add0(d) + ' 00:00:00';//开始
			var e = y + '-' + add0(m) + '-' + add0(d) + ' 23:59:59';//结束
			return [s,e];
		},
		//获取最近7天时间
		getLastSevenDate: function () {
			var dateTime = [];
			var today = new Date();
			var sevenFirstDay = new Date(today.setTime(today.getTime() - 7 * 24 * 60 * 60 * 1000));
			var y = sevenFirstDay.getFullYear();
			var m = sevenFirstDay.getMonth() + 1;
			var d = sevenFirstDay.getDate();
			var s = y + '-' + add0(m) + '-' + add0(d) + ' 00:00:00';//开始
			var e = this.getTodayDate();//结束
			return [s,e.end];
		},
		//获取最近30天时间
		getLastThirtyDate: function () {
			var dateTime = [];
			var today = new Date();
			var thirtyFirstDay = new Date(today.setTime(today.getTime() - 30 * 24 * 60 * 60 * 1000));
			var y = thirtyFirstDay.getFullYear();
			var m = thirtyFirstDay.getMonth() + 1;
			var d = thirtyFirstDay.getDate();
			var s = y + '-' + add0(m) + '-' + add0(d) + ' 00:00:00';//开始
			var e = this.getTodayDate();//结束
			return [s,e.end];
		},
		//获取本周开始时间结束时间
		getCurrentWeek: function () {
			var startStop = new Array();
			//获取当前时间
			var currentDate = new Date();
			//返回date是一周中的某一天
			var week = currentDate.getDay();
			//返回date是一个月中的某一天
			var month = currentDate.getDate();
			//一天的毫秒数
			var millisecond = 1000 * 60 * 60 * 24;
			//减去的天数
			var minusDay = week != 0 ? week - 1 : 6;
			//alert(minusDay);
			//本周 周一
			var monday = new Date(currentDate.getTime() - (minusDay * millisecond));
			//本周 周日
			var sunday = new Date(monday.getTime() + (6 * millisecond));
			var sy = monday.getFullYear();
			var sm = monday.getMonth() + 1;
			var sd = monday.getDate();
			var ey = sunday.getFullYear();
			var em = sunday.getMonth() + 1;
			var ed = sunday.getDate();
			var s = sy + '-' + add0(sm) + '-' + add0(sd) + ' 00:00:00';//开始
			var e = ey + '-' + add0(em) + '-' + add0(ed) + ' 23:59:59';//结束
			return [s,e];
		},
		//获取上周时间
		getLastWeek: function () {
			//起止日期数组
			var startStop = new Array();
			//获取当前时间
			var currentDate = new Date();
			//返回date是一周中的某一天
			var week = currentDate.getDay();
			//返回date是一个月中的某一天
			var month = currentDate.getDate();
			//一天的毫秒数
			var millisecond = 1000 * 60 * 60 * 24;
			//减去的天数
			var minusDay = week != 0 ? week - 1 : 6;
			//获得当前周的第一天
			var currentWeekDayOne = new Date(currentDate.getTime() - (millisecond * minusDay));
			//上周最后一天即本周开始的前一天
			var priorWeekLastDay = new Date(currentWeekDayOne.getTime() - millisecond);
			//上周的第一天
			var priorWeekFirstDay = new Date(priorWeekLastDay.getTime() - (millisecond * 6));
			var sy = priorWeekFirstDay.getFullYear();
			var sm = priorWeekFirstDay.getMonth() + 1;
			var sd = priorWeekFirstDay.getDate();
			var ey = priorWeekLastDay.getFullYear();
			var em = priorWeekLastDay.getMonth() + 1;
			var ed = priorWeekLastDay.getDate();
			var s = sy + '-' + add0(sm) + '-' + add0(sd) + ' 00:00:00';//开始
			var e = ey + '-' + add0(em) + '-' + add0(ed) + ' 23:59:59';//结束
			return [s,e];
		},
		//获取本月时间
		getCurrentMonth: function () {
			//起止日期数组
			var startStop = new Array();
			//获取当前时间
			var currentDate = new Date();
			//获得当前月份0-11
			var currentMonth = currentDate.getMonth();
			//获得当前年份4位年
			var currentYear = currentDate.getFullYear();
			//求出本月第一天
			var firstDay = new Date(currentYear, currentMonth, 1);

			//当为12月的时候年份需要加1
			//月份需要更新为0 也就是下一年的第一个月
			if (currentMonth == 11) {
			  currentYear++;
			  currentMonth = 0; //就为
			} else {
			  //否则只是月份增加,以便求的下一月的第一天
			  currentMonth++;
			}
			//一天的毫秒数
			var millisecond = 1000 * 60 * 60 * 24;
			//下月的第一天
			var nextMonthDayOne = new Date(currentYear, currentMonth, 1);
			//求出上月的最后一天
			var lastDay = new Date(nextMonthDayOne.getTime() - millisecond);
			var sy = firstDay.getFullYear();
			var sm = firstDay.getMonth() + 1;
			var sd = firstDay.getDate();
			var ey = lastDay.getFullYear();
			var em = lastDay.getMonth() + 1;
			var ed = lastDay.getDate();
			var s = sy + '-' + add0(sm) + '-' + add0(sd) + ' 00:00:00';//开始
			var e = ey + '-' + add0(em) + '-' + add0(ed) + ' 23:59:59';//结束
			return [s,e];
		},
		//获取上月时间
		getLastMonth: function () {
			var startStop = new Array();
			//获取当前时间
			var currentDate = new Date();
			//获得当前月份0-11
			var currentMonth = currentDate.getMonth();
			//获得当前年份4位年
			var currentYear = currentDate.getFullYear();
			//获得上一个月的第一天
			var priorMonthFirstDay = getPriorMonthFirstDay(currentYear, currentMonth);
			//获得上一月的最后一天
			var priorMonthLastDay = new Date(priorMonthFirstDay.getFullYear(), priorMonthFirstDay.getMonth(),
			  getMonthDays(priorMonthFirstDay.getFullYear(), priorMonthFirstDay.getMonth()));
			var sy = priorMonthFirstDay.getFullYear();
			var sm = priorMonthFirstDay.getMonth() + 1;
			var sd = priorMonthFirstDay.getDate();
			var ey = priorMonthLastDay.getFullYear();
			var em = priorMonthLastDay.getMonth() + 1;
			var ed = priorMonthLastDay.getDate();
			var s = sy + '-' + add0(sm) + '-' + add0(sd) + ' 00:00:00';//开始
			var e = ey + '-' + add0(em) + '-' + add0(ed) + ' 23:59:59';//结束
			return [s,e];
		}
	}
	//输出接口
	exports('laydatePlus', laydatePlus);
});   