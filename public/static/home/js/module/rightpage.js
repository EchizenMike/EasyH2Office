layui.define(['layer'], function(exports){
    var layer = layui.layer;
    var obj = {
        open: function (content='',width='88%',callback) {
            layer.open({
                type: 2,
                title: '',
                offset: ['1px', '100%'],
                skin: 'layui-anim layui-anim-rl layui-layer-admin-right',
                closeBtn: 0,
                content: content,
                area: [width, '100%'],
				success:function(obj,index){
					if($('#rightPopup'+index).length<1){
						var btn='<div id="rightPopup'+index+'" class="right-popup-close" title="关闭">关闭</div>';
						obj.append(btn);
						$('#rightPopup'+index).click(function(){
						let op_width = $('.layui-anim-rl').outerWidth();
						$('.layui-anim-rl').animate({left:'+='+op_width+'px'}, 200, 'linear', function () {
							$('.layui-anim-rl').remove()
							$('.layui-layer-shade').remove()
						})
							/*
							//callback
							if(callback && typeof callback === 'function'){
								callback(obj);
							}
							*/
						})
					}
				}
            })
			/*
			//点击背景关闭
            let op_width = $('.layui-anim-rl').outerWidth();
            $('.layui-layer-shade').off('click').on('click', function () {
                $('.layui-anim-rl').animate({left:'+='+op_width+'px'}, 300, 'linear', function () {
                    $('.layui-anim-rl').remove()
                    $('.layui-layer-shade').remove()
                })

            })
			*/
        }
    };
    exports('rightpage', obj);
});
