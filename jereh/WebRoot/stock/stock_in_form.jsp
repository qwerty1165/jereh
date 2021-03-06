<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <title>单据界面</title>
 	<script src="/jereh/js/jquery-1.7.2.min.js"></script>
	<script src="/jereh/js/jquery.easyui.min.js"></script>
	<link type="text/css" href="/jereh/themes/icon.css" rel="stylesheet" />
	<link type="text/css" href="/jereh/themes/default/easyui.css" rel="stylesheet"/>
  <style>
   
  td{padding:2px;}
  .td1{width:200px;}
  .td2{width:500px;}
  </style>
 
  <script type="text/javascript">
  $.ajax({url:'/jereh/BaseContent/GetCategoryJsonServlet',
		success:function(data){//data是GetChannelServlet中取得的json数据	
			if(data.total==0){
				alert("没有数据！");	
			}else{			
				for(var i=0;i<data.length;i++){
					//在select下拉列表中增加选项
					$("<option>").appendTo("select[name='inType']")
					.html(data[i].categoryCode).val(data[i].categoryCode);//设置显示内容以及属性值
				}
			}
		},
		dataType:'json'//数据类型【可略】
	});
  </script>
  </head>
  
  <body>
   <div id="dg" style="padding:20px">
		<form name="frm" action="" method="post" >
		<input type="hidden" name="id" /> 
		<input type="hidden" name="opt" />
			<table   border="1" bordercolor="#EBEBEB"  cellpadding="0" cellspacing="0">
			<tr>
			    <td class="td1"><span style="color:red">*</span>入库单号：</td><td class="td2"><input name="code" type="text"/></td>
			    <td class="td1"><span style="color:red">*</span>入库日期：</td><td class="td2"><input name="addDate" type="text" class="easyui-datebox"/></td>
			</tr>
			<tr>
			 <td class="td1"><span style="color:red">*</span>供应商名：</td><td class="td2"><input name="supplierName" type="text" /></td>
			 <td class="td1"><span style="color:red">*</span>联系人员：</td><td class="td2"><input name="contacter" type="text" /></td>			 
			</tr>
			<tr>
				<td class="td1">电话：</td><td class="td2"><input name="telphone" type="text" /></td>
			    <td class="td1">传真：</td><td class="td2"><input name="fax" type="text"/></td>
			</tr>
			<tr>
				<td class="td1">入库类型：</td><td class="td2"><select name="inType"></select><input name="isRoad" type="radio" value="0"/>正常入库<input name="isRoad" type="radio" value="1"/>冲抵入库</td>
			    <td class="td1"><span style="color:red">*</span>是否开票</td><td class="td2"><input name="isInvoice" type="radio" value="1"/>是<input name="fax" type="radio" value="0"/>否</td>
			</tr>
			<tr>
				<td class="td1">备注：</td><td colspan="3" class="td2"><input name="remarks" type="text"/></td>
			    
			</tr>
			</table><br/>
			<input type="button" value="新增" onclick="" />
			<input type="button" value="采购订单" onclick="" />
			<input type="button" value="添加配件" onclick="" />
			<input type="button" value="保存" onclick="" />
			<input type="button" value="审核" onclick="" />
			<input type="button" value="撤销" onclick="" />
			<input type="button" value="生成采购付款" onclick="" />
			<input type="button" value="生成采购收票" onclick="" />
			<input type="button" value="打印" onclick="exportWord()" />
			<input type="button" name="close" value="关闭" onclick="closeDailog();" />
		</form>
	</div>	
  </body>
</html>
