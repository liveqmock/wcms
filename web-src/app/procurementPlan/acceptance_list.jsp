<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>验收确认</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>

<script type="text/javascript">
	$(function(){
		
		$('.datebox').datebox({
			editable:false
		});
		
		$('#goodsList').datagrid({
			url: '<%=request.getContextPath()%>/contract/getAcceptItemList',
			title:'待验收列表',
			toolbar:[
			   {iconCls : 'icon-ok', text : '验收', 
				handler: function(){
					var data = $('#goodsList').datagrid('getSelected');
					if(data==null){
				 		msgShow('提示', '请选中需要验收的物品' , 'warning');
				 		return;
				 	}
					
					if(data.unReceive != 0){
						accept(data);
					}else{
						msgShow('提示', '该物品已验收完成', 'warning');
					}
				}
			}],
			fitColumns: true,
			striped: true,
			singleSelect:false,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'id',  width:20, align:'center',
					formatter:function(value, rowData, rowIndex){
						if(rowData.receive == 0){
							return '<div style="width:10px;height:10px;background-color:red"></div>';	
						}else if(rowData.receive != 0 && rowData.receive < rowData.amount){
							return '<div style="width:10px;height:10px;background-color:yellow"></div>';
						}else if(rowData.unReceive == 0){
							return '<div style="width:10px;height:10px;background-color:blue"></div>';
						}
					}
				},
				{field:'applyNo',title:'计划单号',width:80},
				{field:'goodsName',title:'物品名称',width:80},
				{field:'model',title:'规格',width:80},
				{field:'brand',title:'品牌',width:80},
				{field:'supply',title:'供货单位',width:80},
				{field:'unitName',title:'单位',width:80},
				{field:'arriveDate',title:'约定到货时间',width:80},
				{field:'amount',title:'购买数量',width:80},
				{field:'receive',title:'已到货',width:80},
				{field:'unReceive',title:'未到货',width:80}
			]],
		});
		
		var p = $('#goodsList').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		
		$('#search-status').combobox({
			data:[{'id':0,'text':'全部'},{'id':1,'text':'未验收'},{'id':2,'text':'部分验收'},{'id':3,'text':'验收完成'}],
			valueField:'id',
			textField:'text',
			editable:false
		});
		
		//加载所有仓库
		$('#entrepot').combobox({
			url:'<%=request.getContextPath()%>/entrepot/getEntrepotTree',
			valueField:'id',
			textField:'text',
			required:true,
			editable:false,
			onChange:function(newValue, oldValue){
				$('#shelf').combobox({
					url:'<%=request.getContextPath()%>/entrepot/getAllShelfsByEid?eid=' + newValue
				});
			}
		});
		
		//初始化货架
		$('#shelf').combobox({
			valueField:'id',
			textField:'name',
			required:true,
			editable:false
		});
		
		$('#acceptForm').form({
			url:'<%=request.getContextPath()%>/contract/addAccept',
			onSubmit:function(){
				if($(this).form('validate')){
					MaskUtil.mask();
				}
				$('#entrepot-hidden').val($('#entrepot').combobox('getValue'));
				$('#shelf-hidden').val($('#shelf').combobox('getValue'));
				return $(this).form('validate');
			},
			success:function(data){
				MaskUtil.unmask();
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#acceptWin').window('close');
					$('#goodsList').datagrid('reload');
					$('#acceptForm').form('reset');
				}else{
					msgShow('提示',data.msg,'error');
				}
			}
		});
		
		$('#acceptSave').on('click', function(){
			$('#acceptForm').submit();
		});
		
		$('#acceptWin').window({
			title: '验收',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:300
		});
		
		
	});
	
	//验收
	function accept(data){
		$('#applyNo').html(data.applyNo);
		$('#goodsName').html(data.goodsName);
		$('#model').html(data.model);
		$('#brand').html(data.brand);
		$('#unitName').html(data.unitName);
		$('#amount').html(data.amount);
		$('#receive').html(data.receive);
		$('#unReceive').html(data.unReceive);
		
		$('#maxAccept').val(data.amount - data.receive);
		$('#contractDetailId').val(data.contractDetailId);
		$('#goodsId').val(data.goodsId);
		$('#price').val(data.price);
		
		$('#acceptWin').window('open');
	}
	
</script>
</head>
<body>
	<table style="width:100%;height:auto;border: 1px solid #ccc; font-size: 12px;color: #888;padding: 5px;">
		<tr>
			<td style="text-align: right;">
				物品名称：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				型号：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				品牌：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
			<td style="text-align: right;">
				计划单号：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
		</tr>
		
		<tr>
			<td style="text-align: right;">
				供货单位：
			</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;"/>
			</td>
		    <td style="text-align: right;">
				验收状态：
			</td>
			<td style="text-align: left;">
				<input id="search-status"/>	
			</td>
			<td style="text-align: right;">
				到货日期：
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" style="width: 155%; height: 23px;"/>
			</td>
			<td style="text-align: left;">
				至
			</td>
			<td style="text-align: left;">
				<input class="easyui-datebox" style="width: 155%; height: 23px;"/>
			</td>
			<td style="text-align: center;" colspan="2">
				<a id="search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
			</td>
		</tr>
	</table>
	
	<div style="height: 10px;"></div>
	<table id="goodsList"></table>
	
	<div id="acceptWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
       	<div align="center" style="margin:20px;">
       		<input type="hidden" id="maxAccept">
       		<form id="acceptForm" action="#" method="post">
       			<input id="contractDetailId" name="contractDetailId" type="hidden"/>
       			<input id="goodsId" name="goodsId" type="hidden">
       			<input id="price" name="price" type="hidden">
           		<table width="100%" border="0"  align="center" >
           			<tr style="line-height: 25px;">
               			<td style="width: 30%; text-align: right;">计划单号：</td>
               			<td id="applyNo">
               			</td>
           			</tr>
           			<tr style="line-height: 25px;">
               			<td style="width: 30%; text-align: right;">物品名称：</td>
               			<td id="goodsName">
               			</td>
           			</tr>
           			<tr style="line-height: 25px;">
               			<td style="width: 30%; text-align: right;">规格型号：</td>
               			<td id="model">
               			</td>
           			</tr>
           			<tr style="line-height: 25px;">
               			<td style="width: 30%; text-align: right;">品牌：</td>
               			<td id="brand">
               			</td>
           			</tr>
           			<tr style="line-height: 25px;">
               			<td style="width: 30%; text-align: right;">单位：</td>
               			<td id="unitName"></td>
           			</tr>
           			<tr style="line-height: 25px;">
               			<td style="width: 30%; text-align: right;">购买数量：</td>
               			<td id="amount"></td>
           			</tr>
           			<tr style="line-height: 25px;">
               			<td style="width: 30%; text-align: right;">已验收：</td>
               			<td id="receive"></td>
           			</tr>
           			<tr style="line-height: 25px;">
               			<td style="width: 30%; text-align: right;">未验收：</td>
               			<td id="unReceive"></td>
           			</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">本次验收：</td>
               			<td>
               				<input class="easyui-validatebox" name="amount" required="true" 
               					validType="nums" style="width: 200px;"/>
               			</td>
           			</tr>
           			<tr>
						<td style="width: 30%; text-align: right;">仓库：</td>
						<td>
							<input id="entrepot" style="width: 200px;"/>
							<input type="hidden" id="entrepot-hidden" name="entrepot"/>
						</td>
					</tr>
					
					<tr>
						<td style="width: 30%; text-align: right;">货架：</td>
						<td>
							<input id="shelf" style="width: 200px;"/>
							<input type="hidden" id="shelf-hidden" name="shelf"/>
						</td>
					</tr>
           			<tr>
               			<td style="width: 30%; text-align: right;">备注：</td>
               			<td>
               				<textarea name="remark" style="width:200px; height:60px; margin:5px;"></textarea>
               			</td>
           			</tr>
             				
           			<tr>
               			<td style="text-align: center;" colspan="2">
               				<a class="easyui-linkbutton" iconCls="icon-save" id="acceptSave">保存</a>
               			</td>
           			</tr>
           		</table>
       		</form>
       	</div>
	</div>
</body>
</html>