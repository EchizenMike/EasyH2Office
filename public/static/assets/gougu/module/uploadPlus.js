layui.define(['tool'],function(exports){
	let layer = layui.layer,element = layui.element,tool=layui.tool,form = layui.form,upload = layui.upload,uploadIndex=0;
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
	//是否是对象
	function isObject(obj) {
		return Object.prototype.toString.call(obj) === '[object Object]';
	}
	//名称是否合法
	function isValidFileName(fileName) {
		const illegalChars = /[\\\/\*\:"<>|\?]/;
		return !illegalChars.test(fileName);
	}
	const opts={
		"title":'上传文件',
		"url":'/api/index/upload',
		"target":'uploadBtn',
		"targetBox":'uploadBox',
		"use":'attachment',//attachment(附件上传),shard(大文件分片上传),single(单图上传),multi(多图上传),import(excel导入上传)
		"attachment":{
			"type":0,//0ajax多文件模式，1ajax单文件单记录模式
			"exts": 'sldprt|png|jpg|gif|jpeg|doc|docx|ppt|pptx|xls|xlsx|pdf|zip|rar|7z|txt|wps|avi|wmv|mpg|mov|rm|flv|mp4|mp3|wav|wma|flac|midi|dwg|dxf|dwt|xmind', //只允许上传文件格式
			"colmd":4,
			"uidDelete":false,//是否开启只有上传人自己才能删除自己的附件
			"ajaxSave":null,
			"ajaxDelete":null
		},
		"shard":{
			"exts": 'png|jpg|gif|jpeg|doc|docx|ppt|pptx|xls|xlsx|pdf|zip|rar|7z|txt|wps|avi|wmv|mpg|mov|rm|flv|mp4|mp3|wav|wma|flac|midi|dwg|dxf|dwt|xmind', //只允许上传文件格式
		},
		"single":{
			"exts": 'png|jpg|gif|jpeg',
		},
		"multi":{
			"exts": 'png|jpg|gif|jpeg',
			"type":1,
			"max":31,
		},
		"import":{
			"exts": 'xls|xlsx',
			"template":null,
			"tips":'如果导入失败，请根据提示注意检查表格数据。'
		},
		"callback": null
	};
	var uploadPlus = function(options){
		this.settings = $.extend(true,{},opts, options);
		this.settings.index = uploadIndex;
		uploadIndex++;
		let me=this;
		switch (me.settings.use) {
			case "shard":
				//分片上传
				me.shardUpload();
				break;
			case "single":
				me.singleImage();
				break;
			case "multi":
				if(isObject(me.settings.target)){
					me.multiImage();
				}
				else{
					$('#'+me.settings.target).click(function(){
						me.multiImage();
					});
				}
				break;
			case "import":
				me.excelImport();
				break;
			default:
				me.attachment();
		}
	};    
	uploadPlus.prototype = {
		attachment: function () {
			let me = this;
			let box = $('#'+me.settings.targetBox);
			let boxInput = box.find('[data-type="file"]');
			let attachment = me.settings.attachment;
			//删除附件
			box.on('click', '.file-delete', function () {
				let id = $(this).data('id'),file_id = $(this).data('fileid'),uid = $(this).data('uid');
				if (uid != login_admin && attachment.uidDelete==true) {
					layer.msg('你不是该文件的上传人，无权限删除');
					return false;
				}
				let idsStr = boxInput.val(),idsArray = [];
				if (typeof idsStr !== 'undefined' && idsStr != '') {
					idsArray = idsStr.split(",");
					idsArray.remove(file_id);
				}
				tool.ask('确定删除该附件吗？', function(index) {
					if (typeof (attachment.ajaxDelete) === "function") {
						if(attachment.type==1){
							//单文件，单记录删除
							attachment.ajaxDelete(id,file_id);
						}
						else{
							attachment.ajaxDelete(idsArray.join(','));
						}						
					}
					else{
						//虚拟删除
						boxInput.val(idsArray.join(','));
						$('#uploadFile' + id).remove();
					}
					layer.close(index);
				});
			})
			
			//重命名附件
			box.on('click','.name-edit',function(){
				let file_id = $(this).data('fileid');
				let uid = $(this).data('uid');
				if (uid != login_admin && me.settings.uidDelete==true) {
					layer.msg('你不是该文件的上传人，无权限修改');
					return false;
				}
				let name = $(this).data('name');
				let fileext = $(this).data('fileext');
				layer.prompt({
					title: '重命名',
					value: name.replace(/\.[^.]+$/, ""),
					yes: function(index, layero) {
						// 获取文本框输入的值
						var value = layero.find(".layui-layer-input").val();
						if (value!='') {
							if(isValidFileName(value)==false){
								layer.msg('文件名不能包含下列任何字符：\/:*?".<>|');
								return false;
							}
							let new_title = value+'.'+fileext;
							let callback = function (e) {
								layer.msg(e.msg);
								$('#fileItem'+file_id).find('.file-title').html(new_title).attr('title',new_title);
							}
							tool.post("/api/index/file_edit", {id:file_id,title:new_title}, callback);
							layer.close(index);
						} else {
							layer.msg('请填写文件名称');
						}
					}
				})
			})
			//多附件上传
			upload.render({
				elem: '#'+me.settings.target,
				url: me.settings.url,
				accept: 'file',
				exts: attachment.exts,
				multiple: true,
				before: function(obj){
					layer.msg('上传中...', {icon: 16, time: 0});

                    // 👇 捕获上传的文件对象
                    obj.preview(function (index, file, result) {
                        uploadedFile = file;  // ✅ 保存上传的文件对象
                        // file.name 可用于获取文件名
                    });
				},
				done: function(res){
					if (res.code == 0) {

                        // 2025-07-17 添加上传逻辑，将上传的SLDPRT文件上传到Windows服务器
                        // if (res.filename)
                        // alert("上传文件的文件名："+res.data.name)
                        const ext_solidworks = ["SLDPRT","sldprt","SLDASM","sldasm","SLDDRW","slddrw"];
                        const filename = res.data.name;
                        // 传入的文件名字符串
                        // 提取扩展名（小写）
                        const ext = filename.split('.').pop().toLowerCase();

                        // 判断是否在允许的扩展名列表中
                        if (ext_solidworks.includes(ext)) {
                            // ✅ 创建 FormData 并上传到第二个服务器
                            const formData = new FormData();
                            formData.append('file', uploadedFile);  // 使用保存的文件

                            fetch('http://192.168.180.131:5000/upload', {
                                method: 'POST',
                                body: formData
                            })
                                .then(response => response.json())
                                .then(result => {
                                    if (result.message) {
                                        layer.msg('第二次上传成功: ' + result.filename);
                                    } else {
                                        layer.msg('⚠️第二次上传失败: ' + result.error);
                                    }
                                })
                                .catch(error => {
                                    console.error('第二次上传请求失败:', error);
                                    layer.msg('无法连接目标服务器');
                                });
                        }



						//上传成功
						if(attachment.type==0){
							let image=['jpg','jpeg','png','gif'],office=['doc','docx','xls','xlsx','ppt','pptx'];
							let idsStr = boxInput.val(),idsArray = [];
							if (typeof idsStr !== 'undefined' && idsStr != '') {
								idsArray = idsStr.split(",");
							}
							idsArray.push(res.data.id);
							let filesize = tool.renderSize(res.data.filesize),type=0,type_icon = 'icon-xiangmuguanli',ext = 'zip';
							if(res.data.fileext == 'pdf'){
								type=1;
								type_icon = 'icon-kejian';								
								ext = 'pdf';
							}
							if (image.indexOf(res.data.fileext) !== -1) {
								type=1;
								type_icon = 'icon-sucaiguanli';
								ext = 'image';
							}
							if (office.indexOf(res.data.fileext) !== -1) {
								type=2;
								type_icon = 'icon-shenbao';
								ext = 'office';
							}
							
							let view_btn = '<span class="file-ctrl blue" data-ctrl="edit" data-type="'+type+'" data-fileid="'+res.data.id+'" data-ext="'+ext+'" data-filename="'+res.data.name+'" data-href="'+res.data.filepath+'" data-id="'+res.data.id+'" data-uid="'+res.data.uid+'" title="附件操作"><i class="iconfont icon-gengduo1"></i></span>';
							
							let temp = `<div class="layui-col-md${attachment.colmd}" id="uploadFile${res.data.id}">
									<div class="file-card" id="fileItem${res.data.id}">
										<i class="file-icon iconfont ${type_icon}"></i>
										<div class="file-info">
											<div class="file-title" title="${res.data.name}">${res.data.name}</div>
											<div class="file-ops">${filesize}，一分钟前</div>
										</div>
										<div class="file-tool">${view_btn}<span class="name-edit green" style="display:none;" data-id="${res.data.id}" data-fileid="${res.data.id}" id="fileEdit${res.data.id}" data-name="${res.data.name}" data-fileext="${res.data.fileext}" title="重命名"></span><span class="file-delete red" style="display:none;" data-id="${res.data.id}" data-fileid="${res.data.id}" id="fileDel${res.data.id}" title="删除"><i class="iconfont icon-shanchu"></i></span></div>
									</div>
								</div>`;
							boxInput.val(idsArray.join(','));			
							if (typeof (attachment.ajaxSave) === "function") {
								attachment.ajaxSave(idsArray.join(','));
							}
							else{
								box.append(temp);	
								layer.msg(res.msg);
							}
						}
						if(attachment.type==1){
							//单文件，单记录保存
							if (typeof (attachment.ajaxSave) === "function") {
								attachment.ajaxSave(res);
							}
						}
					}else{
						layer.msg(res.msg);
					}
				}
			});
		},
		//单图
		singleImage: function () {
			let me = this;
			let single = upload.render({
				elem: "#"+me.settings.target,
				url: me.settings.url,
				accept: 'images',
				acceptMime:'image/*',
				done: function (res) {
					me.settings.callback(res);
				}
			});
		},
		//多图
		multiImage: function () {
			let me = this;
			let area =[[],['640px','360px'],['928px','610px']];
			$(parent.$('.express-close')).addClass('parent-colse');
			this.layerindex = layer.open({
				'title':me.settings.title,
				'area':area[me.settings.multi.type],
				'content':me.multiRender(),
				end: function(){
					$(parent.$('.express-close')).removeClass('parent-colse');
				},
				'type':1,
				'success':function(){
					if(me.settings.multi.type==1){
						me.uploadOne();	
					}else{
						me.uploadMore();	
					}							
				}
			});
		},
		multiRender: function (){
			let me = this;
			let template_one = '<div class="layui-form p-3">\
						<div class="layui-form-item">\
							<label class="layui-form-label">来源：</label>\
							<div class="layui-input-block">\
								<input type="radio" name="uploadtype" lay-filter="type" value="1" title="本地上传" checked>\
								<input type="radio" name="uploadtype" lay-filter="type" value="2" title="网络图片">\
							</div>\
						</div>\
						<div id="uploadType1">\
							<div class="layui-form-item">\
								<label class="layui-form-label">文件：</label>\
								<div class="layui-input-block">\
									<span class="gougu-upload-files">.jpg、.jpeg、.gif、.png、.bmp</span><button type="button" class="layui-btn layui-btn-normal" id="gouguUploadBtn'+me.settings.index+'">选择文件</button>\
								</div>\
							</div>\
							<div class="layui-form-item">\
								<label class="layui-form-label"></label>\
								<div class="layui-input-block">\
									<span class="gougu-upload-tips">只能上传 .jpg、.jpeg、.gif、.png、.bmp 文件</span>\
								</div>\
							</div>\
							<div class="layui-form-item">\
								<label class="layui-form-label"></label>\
								<div class="layui-input-block" id="gouguUploadChoosed'+me.settings.index+'"></div>\
							</div>\
							<div class="layui-progress upload-progress" lay-showpercent="yes" lay-filter="upload-progress-'+me.settings.index+'" style="margin-bottom:12px; margin-left:100px; width:320px; display:none;">\
							  <div class="layui-progress-bar layui-bg-blue" lay-percent=""><span class="layui-progress-text"></span></div>\
							</div>\
							<div class="layui-form-item layui-form-item-sm">\
								<label class="layui-form-label"></label>\
								<div class="layui-input-block">\
									<button type="button" class="layui-btn" id="uploadNow'+me.settings.index+'">开始上传</button>\
								</div>\
							</div>\
						</div>\
						<div id="uploadType2" style="display:none; width:480px;">\
							<div class="layui-form-item">\
								<label class="layui-form-label">URL地址：</label>\
								<div class="layui-input-block">\
									<input type="text" name="img_url" placeholder="" autocomplete="off" class="layui-input">\
								</div>\
							</div>\
							<div class="layui-form-item">\
								<label class="layui-form-label">图片名称：</label>\
								<div class="layui-input-block">\
									<input type="text" name="img_name" placeholder="" autocomplete="off" class="layui-input">\
								</div>\
							</div>\
							<div class="layui-form-item layui-form-item-sm">\
								<label class="layui-form-label"></label>\
								<div class="layui-input-block">\
									<span class="layui-btn" id="uploadSave'+me.settings.index+'">确定保存</span>\
								</div>\
							</div>\
						</div>\
				</div>';
			let template_more = '<div class="layui-form p-3">\
							<div id="gouguUploadBox'+me.settings.index+'" class="gougu-upload-box select">\
								<div id="gouguUploadBtn'+me.settings.index+'" class="gougu-upload-btn"><div class="gougu-upload-btn-box"><i class="layui-icon layui-icon-addition"></i><br/>点击上传图片</div></div>\
							</div>\
							<div class="layui-progress upload-progress" lay-showpercent="yes" lay-filter="progress-'+me.settings.index+'" style="margin:12px 0; width:900px;">\
								<div class="layui-progress-bar layui-bg-blue" lay-percent=""><span class="layui-progress-text"></span></div>\
							</div>\
							<div class="layui-form-item layui-form-item-sm">\
								<span class="gougu-upload-tips">注：只能上传 jpg、.jpeg、.gif、.png、.bmp 文件，单次最多上传 '+me.settings.max+' 张图片，单张图片最大不要超过10M。</span>\
								<button type="button" class="layui-btn" id="uploadNow'+me.settings.index+'">开始上传</button>\
								<button type="button" class="layui-btn layui-btn-primary" id="uploadClear'+me.settings.index+'">清空列表</button>\
								<button type="button" class="layui-btn layui-btn-normal" id="uploadOk'+me.settings.index+'">提交</button>\
							</div>\
						</div>';
			return me.settings.multi.type==1?template_one:template_more;
		},
		uploadOne:function(){
			let me = this;
			form.render();					
			form.on('radio(type)', function(data){
				if(data.value==1){
					$('#uploadType1').show();
					$('#uploadType2').hide();
				}
				else{
					$('#uploadType1').hide();
					$('#uploadType2').show();
				}
			}); 					
			//选文件
			let uploadOne = upload.render({
				elem: '#gouguUploadBtn'+me.settings.index
				,url: me.settings.url
				,auto: false
				,accept: 'images'
				,acceptMime:'image/*'
				,bindAction: '#uploadNow'+me.settings.index
				,choose: function(obj){
					obj.preview(function(index, file, result){
						$('#gouguUploadChoosed'+me.settings.index).html('已选择：'+file.name);
					});
				}
				,before: function(obj){
					$('.upload-progress').show();
					element.progress('upload-progress-'+me.settings.index, '0%');
				}
				,progress: function(n, elem, e){
					console.log(n);
					element.progress('upload-progress-'+me.settings.index, n + '%');
				}
				,done: function(res){
					layer.msg(res.msg);
					if(res.code==0){
						me.settings.callback(res.data);
						layer.close(me.layerindex);
					}							
				}
			});
					
			$('#uploadSave'+me.settings.index).on('click',function(){
				let url=$('[name="img_url"]').val();
				let name=$('[name="img_name"]').val();
				if(url == ''){
					layer.msg('请输入图片URL');
					return false;
				}
				if(name == ''){
					layer.msg('请输入图片名称');
					return false;
				}
				let res={
					filepath:url,
					name:name,
					id:0
				}
				me.settings.callback(res);
				layer.close(me.layerindex);
			})
		},
		uploadMore:function(){
			let me = this,file_lists=[];
			console.log(file_lists);
			let uploadList = upload.render({
				elem: '#gouguUploadBtn'+me.settings.index
				,elemList: $('#gouguUploadBox'+me.settings.index) //列表元素对象
				,url: me.settings.url
				,accept: 'images'
				,acceptMime:'image/*'
				,multiple: true
				,number: me.settings.max
				,auto: false
				,bindAction: '#uploadNow'+me.settings.index
				,choose: function(obj){
					let that = this;
					let files = this.files = obj.pushFile(); //将每次选择的文件追加到文件队列
					that.elemList.removeClass('select').addClass('selected');
					//读取本地文件
					obj.preview(function(index, file, result){
						let card = $('<div class="gougu-upload-card" id="gouguUploadCard'+index+'">\
												<div class="gougu-upload-card-box">\
													<img alt="'+ file.name +'" class="gougu-upload-card-img" src="'+ result +'">\
													<div class="gougu-upload-card-bar"><div class="layui-progress" lay-filter="progress-card-'+ index +'"><div class="layui-progress-bar" lay-percent=""></div></div></div>\
													<div class="gougu-upload-card-text">'+ file.name +'</div>\
													<div class="gougu-upload-card-reload"><button type="button" class="layui-btn layui-btn-xs">重新上传</button></div>\
													<div class="gougu-upload-card-del" data-index="'+index+'"><button type="button" class="layui-btn layui-btn-xs layui-btn-radius layui-btn-danger"><i class="layui-icon layui-icon-close"></i></button></div>\
												</div>\
											</div>');					
						//单个重传
						card.find('.gougu-upload-card-reload').on('click', function(){
							obj.upload(index, file);
						});
					
						//删除
						card.find('.gougu-upload-card-del').on('click', function(){
							delete files[index]; //删除对应的文件
							card.remove();
							uploadList.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
						});
					
						that.elemList.append(card);
						element.render('progress'); //渲染新加的进度条组件
					});
				}
				,done: function(res, index, upload){ //成功的回调
					let that = this;
					if(res.code==0){
						delete this.files[index]; //删除文件队列已经上传成功的文件
						that.elemList.find('#gouguUploadCard'+ index).addClass('uploadok');
						file_lists.push(res.data);
					}
					else{
						layer.msg(res.msg);
						this.error(index, upload);
					}
				}
				,allDone: function(obj){ //多文件上传完毕后的状态回调
					//console.log(obj);
					layer.msg('上传成功');
					me.settings.callback(file_lists,obj);
					layer.close(me.layerindex);
				}
				,error: function(index, upload){ //错误回调
				  let that = this;
				  let tr = that.elemList.find('#gouguUploadCard'+ index).addClass('reload'); //显示重传
				}
				,progress: function(n, elem, e, index){
					element.progress('progress-card-'+ index, n + '%'); //执行进度条。n 即为返回的进度百分比
				}
			});
			
			$('#uploadClear'+me.settings.index).click(function(){
				$('#gouguUploadBox'+me.settings.index).find('.gougu-upload-card-del').click();						
			})
			$('#uploadOk'+me.settings.index).click(function(){
				if(me.settings.files.length>0){
					me.settings.callback(me.settings.files);
					layer.close(me.layerindex);
				}
				else{
					layer.msg('请先点击开始上传按钮上传');
				}
			})
		},
		//批量导入
		excelImport:function(){
			let me = this;
			$(parent.$('.express-close')).addClass('parent-colse');
			layer.open({
				'title':me.settings.title,
				'type':1,
				'area': ['640px', '320px'],
				'content':'<div class="layui-form layui-import">\
								<div class="mt-4">\
									<div class="layui-form-item">\
										<label class="layui-form-label">选择文件：</label>\
										<div class="layui-input-block">\
											<div class="layui-input-inline" style="width:286px;"><input type="text" id="inputImport'+me.settings.index+'" placeholder=".xls,.xlsx" class="layui-input" readonly></div><button type="button" class="layui-btn layui-btn-normal" id="importSelect'+me.settings.index+'">选择文件</button><a href="'+me.settings.import.template+'" target="_blank" class="layui-btn ml-2">Excel模板下载</a>\
										</div>\
									</div>\
								</div>\
								<div class="layui-form-item py-2">\
									<label class="layui-form-label"></label>\
									<div class="layui-input-block gougu-import-tips">\
										1、只能上传 .xls、.xlsx文件，文件大小 3MB 以内，每次导入不能超过3000条；<br>2、Excel表格数据请勿放在合并的单元格中，格式务必按照模版样本填写；<br>3、'+me.settings.import.tips+'\
									</div>\
								</div>\
								<div class="layui-form-item">\
									<label class="layui-form-label"></label>\
									<div class="layui-input-block">\
										<button type="button" class="layui-btn layui-bg-red" id="btnImport'+me.settings.index+'">上传并导入</button>\
										<span class="red ml-3" id="noteImport'+me.settings.index+'"></span>\
									</div>\
								</div>\
						</div>',
				end: function(){
					$(parent.$('.express-close')).removeClass('parent-colse');
				},
				success: function(layero, idx){
					form.render();
					let noteImport = $('#noteImport'+me.settings.index);
					//选文件
					let uploadImport = upload.render({
						elem: '#importSelect'+me.settings.index
						,url: me.settings.url
						,auto: false
						,accept: 'file' //普通文件
						,acceptMime: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' // 此处设置上传的文件格式
						,exts: 'xls|xlsx' //只允许上传文件格式
						,bindAction: '#btnImport'+me.settings.index
						,choose: function(obj){
							obj.preview(function(index, file, result){
								$('#importSelect'+me.settings.index).html('重新选择');
								$('#inputImport'+me.settings.index).val(file.name);
							});
						}
						,before: function(obj){
							if($('#inputImport'+me.settings.index).val()==''){
								layer.msg('请选择文件');
								return false;
							}
						}
						,progress: function(n, elem, e){
							noteImport.html('文件上转中...');
							if(n==100){
								noteImport.html('数据导入中...');
							}
						}
						,error: function(index, upload){
							uploadImport.reload();
							$('#importSelect'+me.settings.index).html('选择文件');
							$('#inputImport'+me.settings.index).val('');
							noteImport.html('数据导入失败，请重新选择文件或关闭弹层重试');
						}
						,done: function(res, index, upload){
							uploadImport.reload();
							noteImport.html(res.msg);
							layer.msg(res.msg);
							if(res.code==0){
								layer.close(idx);
								me.settings.callback(res);			
							}
							else{
								$('#importSelect'+me.settings.index).html('选择文件');
								$('#inputImport'+me.settings.index).val('');
							}
						}
					});
				}
			});	
		}
	}
	//输出接口
	exports('uploadPlus', uploadPlus);
});