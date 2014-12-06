/** 
 * 使用方法: 
 * 开启:MaskUtil.mask(); 
 * 关闭:MaskUtil.unmask(); 
 *  
 * MaskUtil.mask('其它提示文字...'); 
 */  
var MaskUtil = (function(){  
      
    var $mask,$maskMsg;  
      
    var defMsg = '正在处理，请稍待。。。';  
      
    function init(){  
        if(!$mask){  
            $mask = $("<div class=\"datagrid-mask mymask\"></div>").appendTo("body");  
        }  
        if(!$maskMsg){  
            $maskMsg = $("<div class=\"datagrid-mask-msg mymask\">"+defMsg+"</div>")  
                .appendTo("body").css({'font-size':'12px'});  
        }  
          
        $mask.css({width:"100%",height:$(document).height()});  
          
        $maskMsg.css({  
            left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2  
        });   
                  
    }  
      
    return {  
        mask:function(msg){  
            init();  
            $mask.show();  
            $maskMsg.html(msg||defMsg).show();  
        }  
        ,unmask:function(){  
            $mask.hide();  
            $maskMsg.hide();  
        }  
    }  
      
}());



$(function(){
	tabClose();
	tabCloseEven();
})

//获取左侧导航的图标
function getIcon(menuid){
	var icon = 'icon ';
	$.each(_menus.menus, function(i, n) {
		 $.each(n.menus, function(j, o) {
		 	if(o.menuid==menuid){
				icon += o.icon;
			}
		 })
	})

	return icon;
}

function addTab(subtitle,url,icon){
	if(!$('#tabs').tabs('exists',subtitle)){
		$('#tabs').tabs('add',{
			title:subtitle,
			content:createFrame(url),
			closable:true,
			icon:icon
		});
	}else{
		$('#tabs').tabs('select',subtitle);
		$('#mm-tabupdate').click();
	}
	tabClose();
}

function createFrame(url)
{
	var s = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
	return s;
}

function tabClose()
{
	/*双击关闭TAB选项卡*/
	$(".tabs-inner").dblclick(function(){
		var subtitle = $(this).children(".tabs-closable").text();
		$('#tabs').tabs('close',subtitle);
	})
	/*为选项卡绑定右键*/
	$(".tabs-inner").bind('contextmenu',function(e){
		$('#mm').menu('show', {
			left: e.pageX,
			top: e.pageY
		});

		var subtitle =$(this).children(".tabs-closable").text();

		$('#mm').data("currtab",subtitle);
		$('#tabs').tabs('select',subtitle);
		return false;
	});
}
//绑定右键菜单事件
function tabCloseEven()
{
	//刷新
	$('#mm-tabupdate').click(function(){
		var currTab = $('#tabs').tabs('getSelected');
		var url = $(currTab.panel('options').content).attr('src');
		$('#tabs').tabs('update',{
			tab:currTab,
			options:{
				content:createFrame(url)
			}
		})
	})
	//关闭当前
	$('#mm-tabclose').click(function(){
		var currtab_title = $('#mm').data("currtab");
		$('#tabs').tabs('close',currtab_title);
	})
	//全部关闭
	$('#mm-tabcloseall').click(function(){
		$('.tabs-inner span').each(function(i,n){
			var t = $(n).text();
			$('#tabs').tabs('close',t);
		});
	});
	//关闭除当前之外的TAB
	$('#mm-tabcloseother').click(function(){
		$('#mm-tabcloseright').click();
		$('#mm-tabcloseleft').click();
	});
	//关闭当前右侧的TAB
	$('#mm-tabcloseright').click(function(){
		var nextall = $('.tabs-selected').nextAll();
		if(nextall.length==0){
			//msgShow('系统提示','后边没有啦~~','error');
			alert('后边没有啦~~');
			return false;
		}
		nextall.each(function(i,n){
			var t=$('a:eq(0) span',$(n)).text();
			$('#tabs').tabs('close',t);
		});
		return false;
	});
	//关闭当前左侧的TAB
	$('#mm-tabcloseleft').click(function(){
		var prevall = $('.tabs-selected').prevAll();
		if(prevall.length==0){
			alert('到头了，前边没有啦~~');
			return false;
		}
		prevall.each(function(i,n){
			var t=$('a:eq(0) span',$(n)).text();
			$('#tabs').tabs('close',t);
		});
		return false;
	});

	//退出
	$("#mm-exit").click(function(){
		$('#mm').menu('hide');
	})
}

//弹出信息窗口 title:标题 msgString:提示信息 msgType:信息类型 [error,info,question,warning]
function msgShow(title, msgString, msgType) {
	$.messager.alert(title, msgString, msgType);
}

/**
 * 金额格式化
 * @param s  要格式化的金额
 * @param n  保留小数位
 * @returns {String}
 */
function fmoney(s, n) { 
	n = n > 0 && n <= 20 ? n : 2; 
	s = parseFloat((s + "").replace(/[^\d\.-]/g, "")).toFixed(n) + ""; 
	var l = s.split(".")[0].split("").reverse(), r = s.split(".")[1]; 
	t = ""; 
	for (i = 0; i < l.length; i++) { 
		t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length ? "," : ""); 
	} 
	return t.split("").reverse().join("") + "." + r; 
} 

//判断字符串是否为空字符串  空返回true
function strIsNull(str){
	var flag = true;
	for(i=0;i<str.length;i++){
		if(str.charAt(i) != ' '){
			flag = false;
			break;
		}
	}
	return flag;
}

$.extend($.fn.validatebox.defaults.rules, {
    nums: {
        validator: function(value){
        	var reg = new RegExp("^[0-9]+(.[0-9]+)?$");
            return reg.test(value);
        },
        message: '请输入数字'
    }
});
