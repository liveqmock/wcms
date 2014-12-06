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
        $(function() {
        	$('#entrepotList').datagrid({
        		url:'<%=request.getContextPath()%>/entrepot/getEntrepotList',
    			title: '仓库列表',
    			toolbar:[
    			    {iconCls : 'icon-add', 
    			     text : '新增', 
					 handler: 
					 	function(){
							$('#addWin').window('open');
						}
					},
					{iconCls : 'icon-edit', 
	    			 text : '编辑', 
					 handler: 
					 	function(){
						 	var data = $('#entrepotList').datagrid('getSelected');
						 	if(data==null){
						 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
						 		return;
						 	}
						 	
						 	editEntrepot(data);
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
    				{field:'name',title:'仓库名称',width:80},
    				{field:'code',title:'仓库编码',width:80}
    			]]
    		});
        	
        	var rolePage = $('#entrepotList').datagrid('getPager'); 
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
        	
        	$('#editWin').window({
                title: '编辑',
                width: 520,
                modal: true,
                shadow: true,
                closed: true,
                height: 450,
            	left: (screen.width-800)/2,
            	top:(screen.height-750)/2
            });
        	
        	$('#addForm').form({
        		url:'<%=request.getContextPath()%>/entrepot/addEntrepot',
        		onSubmit:function(){
        			if($(this).form('validate')){
    					MaskUtil.mask();
    				}
    				return $(this).form('validate');
        		},
        		success:function(data){
        			MaskUtil.unmask();
    				var data = eval('(' + data + ')');
    				if(data.flag){
    					msgShow('提示','保存成功','info');
    					$('#addWin').window('close');
    					$('#entrepotList').datagrid('reload');
    				}else{
    					msgShow('提示','保存失败','error');
    				}
        		}
        	});
        	
        	$('#add-save').on('click', function(){
        		$('#addForm').submit();
        	});
        	
        	$('#add-cancel').on('click', function(){
        		$('#addWin').window('close');
        	});
        	
        	$('#editForm').form({
        		url:'<%=request.getContextPath()%>/entrepot/updateEntrepot',
        		onSubmit:function(){
        			if($(this).form('validate')){
    					MaskUtil.mask();
    				}
    				return $(this).form('validate');
        		},
        		success:function(data){
        			MaskUtil.unmask();
    				var data = eval('(' + data + ')');
    				if(data.flag){
    					msgShow('提示','更新成功','info');
    					$('#editWin').window('close');
    					$('#entrepotList').datagrid('reload');
    				}else{
    					msgShow('提示','更新失败','error');
    				}
        		}
        	});
        	
        	$('#edit-save').on('click', function(){
        		$('#editForm').submit();
        	});
        	
        	$('#edit-cancel').on('click', function(){
        		$('editWin').window('close');
        	});
        });
		
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
        
        //新增仓库
        function addEntrepot(){
        	$('#addWin').window('open');
        }
        
        //编辑仓库
        function editEntrepot(data){
        	$('#editForm').form('load', data);
			$('#editWin').window('open');
        }
    </script>
    </head>
    <body class="easyui-layout" style="overflow-y: hidden"  scroll="no">
		<div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
      		
      		<table id="entrepotList"></table>
    		
    		<div id="addWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
        		<form action="#" id="addForm" method="post">
        			<input type="hidden" name="pid" id="pid" value="0">
        			<table style="width: 500px;">
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						仓库名称：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc; padding-left: 10px;">
        						<input name="name" id="addName" style="width: 250px;" class="easyui-validatebox"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						仓库编码：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="code" id="addCode" style="width: 250px;" class="easyui-validatebox"/>
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
        	
        	<div id="editWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-edit">
        		<form action="#" id="editForm" method="post">
        			<input type="hidden" name="id" id="id" value="0">
        			<table style="width: 500px;">
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						仓库名称：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc; padding-left: 10px;">
        						<input name="name" id="editName" style="width: 250px;" class="easyui-validatebox"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						仓库编码：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="code" id="editCode" style="width: 250px;" class="easyui-validatebox"/>
        					</td>
        				</tr>
        			</table>
        		</form>
        		<div style="height: 20px;"></div>
        		<table style="width: 100%;">
    	  			<tr>
    	  				<td style="text-align: center;">
    	  					<a id="edit-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
                			<a id="edit-cancel" class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
    	  				</td>
    	  			</tr>
    			</table>
        	</div>
    	</div>
	</body>
</html>
