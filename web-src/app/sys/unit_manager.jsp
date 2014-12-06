<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <title>综合管理系统</title>
	<meta charset="utf-8">
    <link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
	<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
	<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/outlook2.js"> </script>
    <script type="text/javascript">
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
        
        $(function() {
        	$('#unitList').datagrid({
        		url:'<%=request.getContextPath()%>/sys/getUnitList',
    			title: '单位列表',
    			toolbar:[
    			    {iconCls : 'icon-add', 
    			     text : '新增', 
					 handler: 
					 	function(){
							$('#addWin').window('open');
						}
					}
    			],
    			fitColumns: true,
    			striped: true,
    			singleSelect:true,
    			rownumbers:true,
    			pagination:true,
    			columns:[[
    			    {field:'id', title:'ID',width:80},
    				{field:'name',title:'单位名称',width:80}
    			]]
    		});
        	
        	var rolePage = $('#unitList').datagrid('getPager'); 
    		rolePage.pagination({  
    	        pageSize : 10,// 每页显示的记录条数，默认为20  
    	        pageList : [10,20,30],// 可以设置每页记录条数的列表  
    	        beforePageText : '第',// 页数文本框前显示的汉字  
    	        afterPageText : '页    共 {pages} 页',  
    	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
    	    });
        	
        	$('#addWin').window({
                title: '新增',
                width: 520,
                modal: true,
                shadow: true,
                closed: true,
                height: 450,
            	left: (screen.width-800)/2,
            	top:(screen.height-750)/2
            });
        	
        	$('#add-save').on('click', function(){
        		if(strIsNull($('#addName').val())){
        			msgShow('缺少信息','单位名称不能为空','warning');
        			return;
        		}
        		
        		$.ajax({
        			url:"<%=request.getContextPath()%>/sys/saveUnit",
    				type:"post",
    				data:$('#addForm').serialize(),
    				dataType:"json",
    				success:function(data, textStatus){
    					if(data.flag){
    						msgShow('提示','保存成功','info');
    						$('#addName').val('');
    						$('#addWin').window('close');
    						$('#unitList').datagrid('reload');
    					}else{
    						msgShow('提示','保存失败','error');
    					}
    				},
    				error:function(){
    					msgShow('提示', '保存失败' , 'error');
    				},
    				async:false
        		});
        	});
        	
        	$('#add-cancel').on('click', function(){
        		$('#addWin').window('close');
        	});
        });
		
		
    </script>
    </head>
    <body class="easyui-layout" style="overflow-y: hidden"  scroll="no">
		<div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
      		
      		<table id="unitList"></table>
    		
    		<div id="addWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
        		<form action="#" id="addForm">
        			<table style="width: 500px;">
        				<tr style="line-height: 100px;">
        					<td style=" width: 20%;text-align: right;">
        						单位名称：
        					</td>
        					<td style="padding-left: 10px;">
        						<input name="name" id="addName" style="width: 250px;"/>
        					</td>
        				</tr>
        			</table>
        		</form>
        		<div style="height: 20px;"></div>
        		<table style="width: 100%;">
    	  			<tr>
    	  				<td style="text-align: center;">
    	  					<a id="add-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
                			<a id="add-cancel" class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
    	  				</td>
    	  			</tr>
    			</table>
        	</div>
    	</div>
	</body>
</html>
