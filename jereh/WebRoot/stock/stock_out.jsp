<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>出库单据管理</title>
<script src="/jereh/js/jquery-1.7.2.min.js"></script>
<script src="/jereh/js/jquery.easyui.min.js"></script>
<link type="text/css" href="/jereh/themes/icon.css" rel="stylesheet" />
<link type="text/css" href="/jereh/themes/default/easyui.css" rel="stylesheet"/>

<script type="text/javascript">
function getCurDate(){
	var date = new Date();
	var year = date.getFullYear();
	var month = date.getMonth() + 1;
	var day = date.getDate();
	var h = date.getHours();
	var m = date.getMinutes();
	var s=date.getSeconds();
	return "MTCK"+year+month+day+h+m+s;
}
$(function(){
	//格式化日期
	$("input.easyui-datebox").datebox({
		formatter:function(date){
			var y = date.getFullYear();
			var m = date.getMonth() + 1;
			var d = date.getDate();		
			return y+"-"+m+"-"+d;   
		},
		parse:function(date){
			var time = Date.parse(date);
			if(!isNaN(time))
				return new Date(time);
			else
				return new Date();
		}
	});
		//弹出添加窗口
  	$("#dg").dialog({
  		resizable:true,
  		fit:true,		
		modal:true,
		closed:true,
		collapsible:true			
	});  
	$("#dg").dialog("close");
	
	 $("#customer").dialog({		
		width:800,high:400,
		modal:true,
		closed:true			
	});	
	$("#customer").dialog("close");
	
		$("#parts").dialog({		
		width:800,high:400,
		modal:true,
		closed:true			
	});	
	$("#parts").dialog("close");
	
	$("#detailInfo").hide();
	
	$("#list").datagrid({
		url:'/jereh/StockOut/GetStockOutServlet',	
		idField:'code',		
		singleSelect:false,
		success:function(data){//data是GetChannelServlet中取得的json数据	
			if(data.total==0){
				alert("没有数据！");	
			}
		},
		toolbar:'#tools',
		columns:[[
					{field:'id',checkbox:true},
					{field:'code',title:'出库单号',fixed:true
						,formatter:function(val,row,idx){							
							return "<a onclick=\"detail('"+row.code+"')\" href='#' >"+val+"</a>";
						}
					},	 				
					{field:'isInvoice',title:'是否开票',hidden:true},					
					{field:'customerCode',title:'客户编号',fixed:true},
					{field:'contacter',title:'联系人',hidden:true},
					{field:'telphone',title:'电话',hidden:true},
					{field:'fax',title:'传真',hidden:true}, 
					{field:'isShow',title:'是否显示',hidden:true},
					{field:'address',title:'地址',hidden:true},
					
					{field:'outDate',title:'出库日期',fixed:true},					
					{field:'customerName',title:'客户名称',fixed:true},
					{field:'nums',title:'数量',fixed:80},
					{field:'numsPrice',title:'总货值',fixed:true},
					
					{field:'payState',title:'付款情况',fixed:true
						,formatter:function(val,row,idx){							
							return "0.00";
						}
					},
					{field:'getState',title:'开票情况',fixed:true
						,formatter:function(val,row,idx){							
							return "0.00";
						}
					},					
					{field:'scstate',title:'审核状态',fixed:true
						,formatter:function(val,row,idx){							
								return "审核中";						
						}
					},	
					{field:'addUserName',title:'操作员',fixed:true},
					{field:'opt',title:'操作',fixed:true
					,formatter:function(val,row,idx){
							var opt="<input type='button' value='删除' onclick=\"delRow('"+row.code+"')\"/>";
							opt+="<input type='button' value='修改'  onclick='updateRow("+idx+")'/>";							
							return opt; 
						}
					}
				]],				
		pagination:true,//分页 
		pageList:[3,5,10],//设置分页尺寸下拉列表中的数据
		pageSize:10
	});	
});

function detail(outcode){
	$("#codeInfo").text(outcode);
	$("#detailInfo").show();
	$("#detailList").datagrid({
		url:'/jereh/StockOut/GetStockOutDetailServlet',		
		queryParams:{'outCode':outcode},		
		success:function(data){//data是GetChannelServlet中取得的json数据	
			if(data.total==0){
				alert("没有数据！");	
			}
		},		
		columns:[[	{field:'xsCode',title:'销售编号',fixed:true},
					{field:'pCode',title:'件号',fixed:true},									
					{field:'baseParts',title:'配件名称',fixed:true,
						formatter:function(val,row,idx){
							return val.partsName;
						}
					},
					{field:'baseParts',title:'配件品牌',fixed:true,
						formatter:function(val,row,idx){
							return val.partsBrand;
						}
					},
					{field:'baseParts',title:'配件型号',fixed:true,
						formatter:function(val,row,idx){
							return val.partsModel;
						}
					},									
					{field:'nums',title:'数量',fixed:true},
					{field:'price',title:'单价',fixed:true},
					{field:'payState',title:'金额',fixed:true,
						formatter:function(val,row,idx){
							return row.nums*row.price;
						}
					},
					{field:'wareHouse',title:'所属仓库',fixed:true},	
					{field:'wnums',title:'库存量',fixed:true},					
					{field:'remarks',title:'备注',fixed:true},					
				]],			
	});		
}

function showDailog(stitle){
	$("#dg").dialog({title:stitle});
	$("#dg").dialog("open");
}
function closeDailog(){
	$("#dg").dialog("close");
}
/**添加数据*/
function addRow(){
	showDailog("添加出库数据");	
	$("#update").hide();
	
	$("input[name='add']").attr("disabled",false);
	$("input[name='save']").attr("disabled",true);	
	$("input[name='opt']").val("1");//opt=1表示添加，opt=2表示修改	
	//清空数据
	$("input[name='code']").val(getCurDate()).attr("readonly",false);
	$("#outDate").datebox("setValue",new Date());		
	$("input[name='customerName']").val("");	
	$("input[name='contacter']").val("");
	$("input[name='telphone']").val("");
	$("input[name='fax']").val("");
	$("input[name='numsPrice']").val("");	
		$("input[name='isShow']:first").prop("checked",true);	
		$("input[name='isInvoice']:first").prop("checked",true);	
	$("input[name='remarks']").val("");	
}
/**更新数据*/
function updateRow(idx){
	showDailog("修改出库数据");
	$("#update").show();
	$("input[name='add']").attr("disabled",true);
	$("input[name='save']").attr("disabled",false);	
	$("input[name='opt']").val("2");
	var row=$("#list").datagrid("getRows")[idx];	 
	var code=row.code;
	var outDate=row.outDate;
	var customerCode=row.customerCode;
	var customerName=row.customerName;
	var contacter=row.contacter;
	var telphone=row.telphone;
	var fax=row.fax;
	var address=row.address;
	var numsPrice=row.numsPrice;	
	var isInvoice=row.isInvioce;
	var isShow=row.isShow;
	var remarks=row.remarks;
	
	$("input[name='customerCode']").val(customerCode);
	$("input[name='address']").val(address);
	$("input[name='code']").val(code).attr("readonly",true);
	$("#outDate").datebox("setValue",outDate);		
	$("input[name='customerName']").val(customerName);	
	$("input[name='contacter']").val(contacter);
	$("input[name='telphone']").val(telphone);
	$("input[name='fax']").val(fax);
	$("input[name='numsPrice']").val(numsPrice);	
	if(isInvoice==1){
		$("input[name='isInvoice']:first").prop("checked",true);
	}else{
		$("input[name='isInvoice']:last").prop("checked",true);
	};	
	if(isShow==1){
		$("input[name='isShow']:first").prop("checked",true);
	}else{
		$("input[name='isShow']:last").prop("checked",true);
	};
	$("input[name='remarks']").val(remarks);	
	
	/**显示详细信息*/
	$("#updateDetailList").datagrid({
		url:'/jereh/StockOut/GetStockOutDetailServlet',		
		queryParams:{'outCode':outcode},		
		success:function(data){//data是GetChannelServlet中取得的json数据	
			if(data.total==0){
				alert("没有数据！");	
			}
		},		
		columns:[[	{field:'xsCode',title:'销售编号',fixed:true},
					{field:'pCode',title:'件号',fixed:true},									
					{field:'baseParts',title:'配件名称',fixed:true,
						formatter:function(val,row,idx){
							return val.partsName;
						}
					},
					{field:'baseParts',title:'配件品牌',fixed:true,
						formatter:function(val,row,idx){
							return val.partsBrand;
						}
					},
					{field:'baseParts',title:'配件型号',fixed:true,
						formatter:function(val,row,idx){
							return val.partsModel;
						}
					},									
					{field:'nums',title:'数量',fixed:true},
					{field:'price',title:'单价',fixed:true},
					{field:'payState',title:'金额',fixed:true,
						formatter:function(val,row,idx){
							return row.nums*row.price;
						}
					},
					{field:'wareHouse',title:'所属仓库',fixed:true},	
					{field:'wnums',title:'库存量',fixed:true},					
					{field:'remarks',title:'备注',fixed:true},	
					{field:'opt',title:'操作',fixed:true
					,formatter:function(val,row,idx){
							var opt="<input type='button' value='删除' onclick=\"delDetail('"+row.code+"')\"/>";
							opt+="<input type='button' value='修改'  onclick='updateDetail("+idx+")'/>";							
							return opt; 
						}
					}					
				]],			
	});		
		
}

/**删除数据*/
function delRow(code){
	//alert(code);
	$.messager.confirm('警告','确定删除该记录吗？',function(r){
		if(r){
			$.ajax({url:'/jereh/StockOut/DeleteStockOutServlet',
				data:{'code':code},
				type:'post',
				success:function(data){
					if(data==1){
						alert("删除成功！");
						$("#list").datagrid("reload");							
					}
				}
			});	
		}
	});	
};
/**添加数据 显示客户信息列表*/
function showSupplier(){
	$("#customer").dialog({title:"请选择客户"});
	$("#customer").dialog("open");
	$("#cusList").datagrid({  
		url:'/jereh/BaseCustomerSupplier/GetBaseCustomerSupplierServlet',
		toolbar:'#cusListTb',
		idField:'code',
		columns:[[
			{field:'code',title:'客户代码',fixed:true},
			{field:'csName',title:'客户名称',fixed:true},
			{field:'contacter',title:'联系人员',fixed:true},
			{field:'telephone',title:'电话',fixed:true},
			{field:'fax',title:'传真',fixed:true},
			{field:'address',title:'地址',fixed:true}
		]],
		onClickRow:function(idx, row){
			var row=$("#cusList").datagrid("getRows")[idx];
			var code=row.code;
			var csName=row.csName;
			var contacter=row.contacter;
			var fax = row.fax;
			var telphone = row.telephone;
			$("input[name='customerCode']").val(code);
			$("input[name='customerName']").val(csName);
			$("input[name='contacter']").val(contacter);
			$("input[name='fax']").val(fax);
			$("input[name='telphone']").val(telphone);	
			$("#customer").dialog("close");	  
		}
	}); 
}
/**配件信息表*/
function addParts(){
   $("#parts").dialog({title:"选择配件"});
   $("#parts").dialog("open");
   $("#parList").datagrid({
       url:'/jereh/StockIn/GetBasePartsServlet',
       toolbar:'#parListTb',
	   idField:'',
       columns:[[{field:'',title:'件号',fixed:true},
       			 {field:'',title:'配件名称',fixed:true},
       			 {field:'',title:'配件品牌',fixed:true},
       			 {field:'',title:'配件型号',fixed:true},
       			 {field:'',title:'数量',fixed:true},
       			 {field:'',title:'单价',fixed:true},
       			 {field:'',title:'金额',fixed:true},
       			 {field:'',title:'所属仓库',fixed:true},       			 
       			 {field:'',title:'备注',fixed:true},
   ]]});  
}

function searchFun(){
	var code=$("input[name='code']").val();
	var startDate=$("input[name='startDate']").val();
	var endDate=$("input[name='endDate']").val();	
	var customerName=$("select[name='customerName']").val();
	$("#list").datagrid("reload",{code:code,startDate:startDate,endDate:endDate,customerName:customerName});	
}

</script>
<style>
#searchFrm{
	background-color:#F4F4F4;
}
  td{padding:2px;}
  .td1{width:200px;}
  .td2{width:500px;}
</style>

</head>

<body>
    <div id="tools" >
    <form id="searchFrm" action="/jereh/StockIn/GetStockInServlet">  <b>检索条件：</b>	        
        入库单号：<input type="text"  name="code"/>
        开始日期:<input type="text" class="easyui-datebox"  name="startDate"/>
        结束日期：<input type="text" class="easyui-datebox"   name="endDate"/>
	供应商名：<input type="text"  name="customerName"/>
        <input type="button" onclick="searchFun()" value="搜索" />
        <input type="reset" value="重置"/>
    </form>
    	<div id="tb">
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchFun()">查询</a>|
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addRow()">增加</a>|
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="delBatchRow()">批量删除</a>|
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="exportExcl()">导出EXCEL</a>
		</div>       
    </div>
    
    
	<div id="list"></div>
    
    <div id="detailInfo">
	   	 单据标号为：<strong id="codeInfo" style="font"></strong>&nbsp;的明细如下所列！
	    <div id="detailList"></div>	
    </div>
	
	<!-- 客户选择 -->    
     <div id="customer">
	     <div id="cusListTb">
		       <form action="" method="post" >
		          <b>检索条件：</b>
		          	客户代码:<input type="text"/> 
		          	客户名称:<input type="text"/>
		          	<input type="button" value="搜索" onclick=""/>
					<input type="reset" value="重置" />
		       </form>
	       </div>
		 <div id="cusList"></div>
     </div>
 	<!-- 配件选择 -->
     <div id="parts">
	     <div id="parListTb">
	       <form action="" method="post" >
	          <b>检索条件：</b>
	          	件号：<input type="text"/> 
	          	名称：<input type="text"/>
	          	仓库：<select class="easyui-combobox">
	          	   <option>--选择仓库--</option>
	          	   <option>主仓库</option>
	          	   </select>          	   
	          	<input type="button" value="搜索" onclick=""/>
				<input type="reset" value="重置" />
	       </form>
	       </div>
	 	<div id="parList"></div>
     </div>		 
	<!-- 更新添加页面 -->   
     <div id="dg" style="padding:20px">
		<form name="frm" action="/jereh/StockOut/UpdateStockOutServlet" method="post" >
			<input type="hidden" name="customerCode" /> 
			<input type="hidden" name="address" /> 
			<input type="hidden" name="opt" />
			<table   border="1"  border="1" bordercolor="#CFDAE8" cellpadding="0"
				cellspacing="0">
			<tr>
			    <td class="td1"><span style="color:red">*</span>出库单号：</td>
			    <td class="td2"><input name="code" type="text"/></td>
			    <td class="td1"><span style="color:red">*</span>出库日期：</td>
			    <td class="td2"><input id="outDate" name="outDate" type="text" class="easyui-datebox"/></td>
			</tr>
			<tr>
			 <td class="td1"><span style="color:red">*</span>客户名称：</td>
			 <td class="td2"><input name="customerName" readonly="readonly" type="text" onclick="showSupplier()"/></td>
			 <td class="td1"><span style="color:red">*</span>联系人员：</td>
			 <td class="td2"><input name="contacter" type="text" readonly="readonly" /></td>			 
			</tr>
			<tr>
				<td class="td1">电话：</td>
				<td class="td2"><input name="telphone" type="text" readonly="readonly" /></td>
			    <td class="td1">传真：</td>
			    <td class="td2"><input name="fax" type="text" readonly="readonly"/></td>
			</tr>
			<tr>
				<td class="td1">出库类型：</td>
				<td class="td2"> <select name="outType" disabled><option value='销售出库'>销售出库</option></select>
			    <td class="td1"><span style="color:red">*</span>是否开票：</td>
			    <td class="td2"><input name="isInvoice" type="radio" value="1"/>是<input name="isInvoice" type="radio" value="0"/>否</td>
			</tr>
			<tr>		
				<td class="td1">是否显示：</td>
				<td class="td2"><input name="isShow" type="radio" value="1"/>是 <input name="isShow" type="radio" value="0"/>否</td>
						
				<td class="td1">备注：</td>
				<td class="td2"><input name="remarks" type="text"/></td>			    
			</tr>
			</table><br/>
			<input name="add" type="submit" value="新增" onclick="" />
			<input name="order" type="button" value="销售订单" onclick="" />
			<input name="part" type="button" value="添加配件" onclick="addParts()" />
			<input name="save" type="submit" value="保存" onclick="" />
			<input name="" type="button" value="审核" onclick="" />
			<input name="" type="reset" value="撤销" onclick="" />
			<input name="" type="button" value="生成采购付款" onclick="" />
			<input name="" type="button" value="生成采购收票" onclick="" />
			<input name="word" type="button" value="打印" onclick="exportWord()" />
			<input name="" type="button" name="close" value="关闭" onclick="closeDailog();" /><br/>
			<br/>
			<div id="update"><div id="updateDetailList"></div></div>
		</form>	
	</div>	
</body>
</html>
