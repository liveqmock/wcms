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
        	$('#tt').tree({
        	    url:'<%=request.getContextPath()%>/sys/getDeptTree',
        	    onClick: function(node){
        	    	$('#pid').val(node.id);
        			$('#deptList').datagrid({url:'<%=request.getContextPath()%>/sys/getDeptsByPid?pid=' + node.id});
        		}
        	});
        	
        	$('#deptList').datagrid({
        		url:'<%=request.getContextPath()%>/sys/getDeptsByPid?pid=1',
    			title: '部门列表',
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
						 	var data = $('#deptList').datagrid('getSelected');
						 	if(data==null){
						 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
						 		return;
						 	}
						 	$('#id').val(data.id);
						 	$('#editName').val(data.name);
						 	$('#editCode').val(data.code);
						 	$('#editOrderNo').val(data.orderNo);
						 	$('#editDesc').val(data.sdesc);
							$('#editWin').window('open');
						}
					}
    			],
    			fitColumns: true,
    			striped: true,
    			singleSelect:true,
    			rownumbers:true,
    			columns:[[
					{field:'id',title:'ID',width:80},
    				{field:'name',title:'部门名称',width:80},
    				{field:'code',title:'部门编码',width:80},
    				{field:'sdesc',title:'部门描述',width:80},
    				{field:'orderNo',title:'排序号',width:80}
    			]],
    			onDblClickRow:function(rowIndex, rowData) {  
    				viewOrder(); 
    	        },
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
        	
        	$('#add-save').on('click', function(){
        		if(strIsNull($('#addName').val())){
        			msgShow('缺少信息','部门名称不能为空','warning');
        			return;
        		}
        		
        		if(strIsNull($('#addCode').val())){
        			msgShow('缺少信息','部门编码不能为空','warning');
        			return;
        		}
        		
        		if(strIsNull($('#addOrderNo').val())){
        			msgShow('缺少信息','排序号不能为空','warning');
        			return;
        		}
        		
        		$.ajax({
        			url:"<%=request.getContextPath()%>/sys/saveDept",
    				type:"post",
    				data:$('#addForm').serialize(),
    				dataType:"json",
    				success:function(data, textStatus){
    					if(data.flag){
    						msgShow('提示','保存成功','info');
    						$('#addWin').window('close');
    						$('#deptList').datagrid('reload');
    						$('#tt').tree('reload');
    						$('#addName').val('');
    						$('#addCode').val('');
    						$('#addDesc').val('');
    						$('#addOrderNo').val('');
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
        	
        	$('#edit-save').on('click', function(){
        		if(strIsNull($('#editName').val())){
        			msgShow('缺少信息','部门名称不能为空','warning');
        			return;
        		}
        		
        		if(strIsNull($('#editCode').val())){
        			msgShow('缺少信息','部门编码不能为空','warning');
        			return;
        		}
        		
        		if(strIsNull($('#editOrderNo').val())){
        			msgShow('缺少信息','排序号不能为空','warning');
        			return;
        		}
        		
        		$.ajax({
        			url:"<%=request.getContextPath()%>/sys/updateDept",
    				type:"post",
    				data:$('#editForm').serialize(),
    				dataType:"json",
    				success:function(data, textStatus){
    					if(data.flag){
    						msgShow('提示','更新成功','info');
    						$('#editWin').window('close');
    						$('#deptList').datagrid('reload');
    						$('#tt').tree('reload');
    					}else{
    						msgShow('提示','更新失败','error');
    					}
    				},
    				error:function(){
    					msgShow('提示', '更新失败' , 'error');
    				},
    				async:false
        		});
        	});
        	
        	$('#edit-cancel').on('click', function(){
        		$('editWin').window('close');
        	});
        });
		
		
    </script>
    </head>
    <body class="easyui-layout" style="overflow-y: hidden"  scroll="no">
		<div region="west" style="width:240px;" id="west">
			<div style="height: 20px;"></div>
      		<ul id="tt" class="easyui-tree"></ul>
    	</div>
		<div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
      		
      		<table id="deptList"></table>
    		
    		<div id="addWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
        		<form action="#" id="addForm">
        			<input type="hidden" name="pid" id="pid" value="1">
        			<table style="width: 500px;">
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						部门名称：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc; padding-left: 10px;">
        						<input name="name" id="addName" style="width: 250px;"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						部门编码：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="code" id="addCode" style="width: 250px;"/>
        					</td>
        				</tr>
        				
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						排序号：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="orderNo" id="addOrderNo" style="width: 250px;"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-bottom:1px solid #ccc;width: 40%;text-align: right;">
        						部门描述：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;border-bottom:1px solid #ccc;padding-left: 10px;">
        						<input name="sdesc" id="addDesc" style="width: 250px;"/>
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
        		<form action="#" id="editForm">
        			<input type="hidden" name="id" id="id" value="0">
        			<table style="width: 500px;">
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						部门名称：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc; padding-left: 10px;">
        						<input name="name" id="editName" style="width: 250px;"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						部门编码：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="code" id="editCode" style="width: 250px;"/>
        					</td>
        				</tr>
        				
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						部门描述：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="sdesc" id="editDesc" style="width: 250px;"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-bottom:1px solid #ccc;width: 40%;text-align: right;">
        						排序号：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;border-bottom:1px solid #ccc;padding-left: 10px;">
        						<input name="orderNo" id="editOrderNo" style="width: 250px;"/>
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
