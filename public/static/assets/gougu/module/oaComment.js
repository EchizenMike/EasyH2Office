layui.define(['tool','oaPicker'], function (exports) {
	const layer = layui.layer, tool = layui.tool;
	const obj = {
		log: function (topic_id, module) {
			let callback = function (res) {
				if (res.code == 0 && res.data.length > 0) {
					let itemLog = '';
					$.each(res.data, function (index, item) {
						if (item.field == 'content') {
							itemLog += `
							<div class="log-item py-3 border-b">
								<i class="iconfont ${item.icon}"></i>
								<span class="log-name">${item.name}</span>
								<span class="log-content gray"> ${item.action}了<strong>${item.title}</strong><i title="对比查看" class="iconfont icon-yuejuan" style="color:#1E9FFF; cursor: pointer;"></i> <span class="gray" title="${item.create_time}">${item.times}</span></span>
							</div>
						`;
						}
						else if (item.field == 'file' || item.field == 'link' || item.field == 'user') {
							itemLog += `
								<div class="log-item py-3 border-b">
									<i class="iconfont ${item.icon}"></i>
									<span class="log-name">${item.name}</span>
									<span class="log-content gray"> ${item.action}了${item.title}<strong>${item.new_content}</strong><span class="gray" title="${item.create_time}">${item.times}</span></span>
								</div>
							`;
						} else if (item.field == 'new' || item.field == 'delete') {
							itemLog += `
								<div class="log-item py-3 border-b">
									<i class="iconfont ${item.icon}"></i>
									<span class="log-name">${item.name}</span>
									<span class="log-content gray"> ${item.action}了<strong>${item.title}</strong><span class="gray" title="${item.create_time}">${item.times}</span></span>
								</div>
							`;
						}
						else if (item.field == 'document') {
							if (item.action == '修改') {
								itemLog += `
									<div class="log-item py-3 border-b">
										<i class="iconfont ${item.icon}"></i>
										<span class="log-name">${item.name}</span>
										<span class="log-content gray"> ${item.action}了${item.title}<strong>${item.remark}</strong><i title="对比查看" class="iconfont icon-yuejuan" style="color:#1E9FFF; cursor: pointer;"></i> <span class="gray" title="${item.create_time}">${item.times}</span></span>
									</div>
								`;
							}
							else {
								itemLog += `
									<div class="log-item py-3 border-b">
										<i class="iconfont ${item.icon}"></i>
										<span class="log-name">${item.name}</span>
										<span class="log-content gray"> ${item.action}了${item.title}<strong>${item.remark}</strong><span class="gray" title="${item.create_time}">${item.times}</span></span>
									</div>
								`;
							}
						}
						else {
							itemLog += `
							<div class="log-item py-3 border-b">
								<i class="iconfont ${item.icon}"></i>
								<span class="log-name">${item.name}</span>
								<span class="log-content gray"> 将<strong>${item.title}</strong>从 ${item.old_content} ${item.action}为<strong>${item.new_content}</strong><span class="gray" title="${item.create_time}">${item.times}</span></span>
							</div>
						`;
						}
					});
					$("#log_" + module + "_" + topic_id).html(itemLog);
				}
			}
			tool.get("/project/api/task_log", { tid: topic_id, m: module }, callback);
		},
		load: function (topic_id, module) {
			let callback = function (res) {
				if (res.code == 0 && res.data.length > 0) {
					let itemComment = '';
					$.each(res.data, function (index, item) {
						let to_names = '', ops = '' ,ptext='';
						if (item.to_uids !='') {
							to_names = '<span class="blue">@' + item.to_names + '</span>';
						}
						if (item.admin_id == login_admin) {
							ops = `<a class="mr-4" data-event="edit" data-id="${item.id}">编辑</a><a class="mr-4" data-event="del" data-id="${item.id}">删除</a>`;
						}
						else{
							ops = `<a class="mr-4" data-event="replay" data-id="${item.id}" data-uid="${item.admin_id}" data-unames="${item.name}">引用</a>`;
						}
						if(item.pid>0){
							ptext=`<div style="padding-bottom:8px;"><fieldset style="border:1px solid #eeeeee; background-color:#f9f9f9;"><legend>引用『${item.padmin}』${item.ptimes}的评论</legend>${item.pcontent}</fieldset></div>`;
						}
						itemComment += `
							<div id="comment_${item.id}" class="comment-item py-3 border-t" data-content="${item.content}">
							<div class="comment-avatar" title="${item.name}">
								<img class="comment-image" src="${item.thumb}">
							</div>
							<div class="comment-body">
								<div class="comment-meta">
									<strong class="comment-name">${item.name}</strong><span class="ml-2 gray" title="${item.create_time}">${item.times}${item.update_time}</span>
								</div>
								<div class="comment-content py-2">${to_names} ${item.content}</div>
								${ptext}
								<div class="comment-actions">${ops}</div>
							</div>
						</div>
						`;
					});
					$("#comment_" + module + "_" + topic_id).html(itemComment);
					layer.closeAll();
				}
			}
			tool.get("/project/api/project_comment", { tid: topic_id, m: module }, callback);
		},
		add: function (id,topic_id, module,content,pid,to_uids) {
			let that = this;
			let callback = function (res) {
				that.load(topic_id, module);
			}
			if (content == '') {
				layer.msg('请完善评论内容');
				return false;
			}
			let postData = { id: id, topic_id: topic_id, pid: pid, to_uids: to_uids, module: module, content: content};
			tool.post("/project/api/add_comment", postData, callback);
		},
		del: function (id, topic_id, module) {
			let that = this;
			layer.confirm('确定删除该评论吗？', {
				icon: 3,
				title: '提示'
			}, function (index) {
				let callback = function (e) {
					layer.msg(e.msg);
					if (e.code == 0) {
						that.load(topic_id, module);
					}
				}
				tool.delete("/project/api/delete_comment", { id: id }, callback);
				layer.close(index);
			});
		},
		//文本
		textarea: function (id, topic_id, module, txt, pid,to_uid,to_uname) {
			let that = this;
			let display='',usersInput='',height='286px';
			if(id==0){
				usersInput='<div class="layui-input-wrap" style="margin-bottom:5px;"><div class="layui-input-prefix"><i class="layui-icon layui-icon-at"></i></div><input type="text" placeholder="要提醒的员工" value="'+to_uname+'" readonly class="layui-input picker-admin" data-type="2" /><input type="hidden" id="to_uids" value="'+to_uid+'" /></div>';
				height='320px';
			}
			$(parent.$('.express-close')).addClass('parent-colse');
			layer.open({
				type: 1,
				title: '请输入评论内容',
				area: ['600px', height],
				content: '<div style="padding:5px;">'+usersInput+'<textarea class="layui-textarea" id="editTextarea" style="width: 100%; height: 160px;">'+txt+'</textarea></div>',
				end: function(){
					$(parent.$('.express-close')).removeClass('parent-colse');
				},
				btnAlign: 'c',
				btn: ['提交保存'],
				yes: function () {
					let to_uids = $("#to_uids").val();
					let newval = $("#editTextarea").val();
					if (newval != '') {
						that.add(id,topic_id, module,newval,pid,to_uids);
					} else {
						layer.msg('请输入评论内容');
					}
				}
			})
		},
		parseUids: function (uids) {
			uids=uids+'';
			var numberArray = uids.split(',');
			var uniqueArray = numberArray.filter((value, index, self) => {
				return self.indexOf(value) === index;
			});
			return uniqueArray.join(',');
		}
	};
	exports('oaComment', obj);
});  