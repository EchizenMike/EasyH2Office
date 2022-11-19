layui.define(['tool'], function (exports) {
	const layer = layui.layer, tool = layui.tool,form=layui.form, table=layui.table, upload = layui.upload;
	// 查找指定的元素在数组中的位置
	Array.prototype.indexOf = function (val) {
		for (var i = 0; i < this.length; i++) {
			if (this[i] == val) {
				return i;
			}
		}
		return -1;
	};
	// 通过索引删除数组元素
	Array.prototype.remove = function (val) {
		var index = this.indexOf(val);
		if (index > -1) {
			this.splice(index, 1);
		}
	};
	
	const obj = {
		addFile: function (options) {
			let that = this;
			let settings = {
				type:0,
				btn: 'uploadBtn',
				box: 'fileBox',
				url: "/api/index/upload",
				accept: 'file', //普通文件
				exts: 'png|jpg|gif|jpeg|doc|docx|ppt|pptx|xls|xlsx|pdf|zip|rar|7z', //只允许上传文件格式
				colmd:4,
				isSave:false,
				ajaxSave:function(val){},
				ajaxDelete:function(val){}
			};
			let opts = $.extend({}, settings, options);
			
			if(opts.type==0){
				//虚拟删除
				$('#'+opts.box).on('click', '.btn-delete', function () {
					let file_id = $(this).data('id');
					let idsStr = $('#'+opts.box+'Input').val(),idsArray = [];
					if (idsStr != '') {
						idsArray = idsStr.split(",");
					}
					idsArray.remove(file_id);
					$('#'+opts.box+'Input').val(idsArray.join(','));
					$('#fileItem' + file_id).remove();
				})
				
				//ajax删除
				$('#'+opts.box).on('click', '.ajax-delete', function () {
					let file_id = $(this).data('id');
					let idsStr = $('#'+opts.box+'Input').val(),idsArray = [];
					if (idsStr != '') {
						idsArray = idsStr.split(",");
					}
					idsArray.remove(file_id);
					layer.confirm('确定删除该附件吗？', {
						icon: 3,
						title: '提示'
					}, function(index) {
						if (typeof (opts.ajaxSave) == "function") {
							opts.ajaxSave(idsArray.join(','));
						}
						layer.close(index);
					});
				})
			}
			if(opts.type==1){
				//ajax删除
				$('#'+opts.box).on('click', '.ajax-delete', function () {
					let file_id = $(this).data('id');
					layer.confirm('确定删除该附件吗？', {
						icon: 3,
						title: '提示'
					}, function(index) {
						if (typeof (opts.ajaxSave) == "function") {
							opts.ajaxDelete(file_id);
						}
						layer.close(index);
					});
				})
			}
			
			//多附件上传
			upload.render({
				elem: '#'+opts.btn,
				url: opts.url,
				accept: opts.accept,
				exts: opts.exts,
				multiple: true,
				done: function(res){
					layer.msg(res.msg);
					if (res.code == 0) {
						//上传成功
						if(opts.type==0){
							let idsStr = $('#'+opts.box+'Input').val(),idsArray = [];
							if (idsStr != '') {
								idsArray = idsStr.split(",");
							}
							idsArray.push(res.data.id);
							$('#'+opts.box+'Input').val(idsArray.join(','));
							let temp = `<div class="layui-col-md${opts.colmd}" id="fileItem${res.data.id}">
									<div class="file-card">
										<i class="file-icon iconfont icon-renwuguanli"></i>
										<div class="file-title">${res.data.name}</div>
										<div class="file-tool">
											<a href="${res.data.filepath}" download="${res.data.name}" title="下载查看" target="_blank"><i class="iconfont icon-shujudaoru blue"></i></a>
											<span class="btn-delete iconfont icon-shanchu red" data-id="${res.data.id}" title="删除"></span>
										</div>
									</div>
								</div>`;
							$('#'+opts.box).append(temp);
							
							if (typeof (opts.ajaxSave) == "function" && opts.isSave ==true) {
								opts.ajaxSave(idsArray.join(','));
							}
						}
						if(opts.type==1){
							if (typeof (opts.ajaxSave) == "function" && opts.isSave ==true) {
								opts.ajaxSave(res);
							}
						}
					}
				}
			});
		},
		customerPicker:function(callback){
			var customeTable;
			layer.open({
				title: '选择客户',
				area: ['600px', '580px'],
				type: 1,
				content: '<div class="picker-table">\
					<form class="layui-form pb-2">\
						<div class="layui-input-inline" style="width:480px;">\
						<input type="text" name="keywords"  placeholder="客户名称" class="layui-input" autocomplete="off" />\
						</div>\
						<button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="search_customer">提交搜索</button>\
				  	</form>\
					<div id="customerTable"></div></div>',
				success: function () {
					customeTable = table.render({
						elem: '#customerTable'
						, url: '/contract/api/get_customer'
						, page: true //开启分页
						, limit: 10
						, cols: [[
							{ type: 'radio', title: '选择' }
							, { field: 'id', width: 100, title: '编号', align: 'center' }
							, { field: 'name', title: '客户名称' }
						]]
					});
					//客户搜索提交
					form.on('submit(search_customer)', function (data) {
						customeTable.reload({ where: { keywords: data.field.keywords }, page: { curr: 1 } });
						return false;
					});
				},
				btn: ['确定'],
				btnAlign: 'c',
				yes: function () {
					var checkStatus = table.checkStatus(customeTable.config.id);
					var data = checkStatus.data;
					if (data.length > 0) {
						callback(data[0]);
						layer.closeAll();
					}
					else {
						layer.msg('请先选择客户');
						return false;
					}
				}
			})
		},
		contractPicker:function(callback){
			var contractTable;
			layer.open({
				title: '选择合同',
				area: ['600px', '580px'],
				type: 1,
				content: '<div class="picker-table">\
					<form class="layui-form pb-2">\
						<div class="layui-input-inline" style="width:480px;">\
						<input type="text" name="keywords"  placeholder="合同名称" class="layui-input" autocomplete="off" />\
						</div>\
						<button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="search_contract">提交搜索</button>\
					</form>\
					<div id="contractTable"></div></div>',
				success: function () {
					contractTable = table.render({
						elem: '#contractTable'
						, url: '/contract/api/get_contract'
						, page: true //开启分页
						, limit: 10
						, cols: [[
							{ type: 'radio', title: '选择' }
							, { field: 'id', width: 100, title: '编号', align: 'center' }
							, { field: 'name', title: '合同名称' }
						]]
					});
					//项目搜索提交
					form.on('submit(search_contract)', function (data) {
						contractTable.reload({ where: { keywords: data.field.keywords }, page: { curr: 1 } });
						return false;
					});
				},
				btn: ['确定'],
				btnAlign: 'c',
				yes: function () {
					var checkStatus = table.checkStatus(contractTable.config.id);
					var data = checkStatus.data;
					if (data.length > 0) {
						callback(data[0]);
						layer.closeAll();
					}
					else {
						layer.msg('请先选择合同');
						return false;
					}
				}
			})
		}
	};
	
	
	//选择客户	
	$('body').on('click','.picker-customer',function () {
		let that = $(this);
		let callback = function(data){
			that.val(data.name);
			that.next.val(data.id);
		}
		obj.customerPicker(callback);
	});
	
	
	//选择合同	
	$('body').on('click','.picker-contract',function () {
		let that = $(this);
		let callback = function(data){
			that.val(data.name);
			that.next.val(data.id);
		}
		obj.contractPicker(callback);
	});
	
	exports('oaTool', obj);
});  