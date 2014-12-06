package com.kiy.wcms.order.entity;


/**
 * 订单明细
 * @author Kiy Peng
 * @date 2014年8月22日
 */
public class OrderDetail {
	/**
	 * 主键
	 */
	private int id;
	/**
	 * 产品名称
	 */
	private String name;
	/**
	 * 规格型号
	 */
	private String model;
	/**
	 * 数量
	 */
	private double quantity;
	/**
	 * 单位
	 */
	private int unitId;
	
	private String unitName;
	/**
	 * 单价
	 */
	private double unitPrice;
	/**
	 * 总价
	 */
	private double total;
	/**
	 * 备注
	 */
	private String remark;
	/**
	 * 订单主键
	 */
	private int orderId;
	/**
	 * 技术参数
	 */
	private String technicalParam;
	/**
	 * 技术部确认
	 */
	private String technicalComment;
	/**
	 * 采购部确认
	 */
	private String procurementComment;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public double getQuantity() {
		return quantity;
	}
	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}
	public double getUnitPrice() {
		return unitPrice;
	}
	public void setUnitPrice(double unitPrice) {
		this.unitPrice = unitPrice;
	}
	public double getTotal() {
		return total;
	}
	public void setTotal(double total) {
		this.total = total;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public String getTechnicalParam() {
		return technicalParam;
	}
	public void setTechnicalParam(String technicalParam) {
		this.technicalParam = technicalParam;
	}
	public String getTechnicalComment() {
		return technicalComment;
	}
	public void setTechnicalComment(String technicalComment) {
		this.technicalComment = technicalComment;
	}
	public String getProcurementComment() {
		return procurementComment;
	}
	public void setProcurementComment(String procurementComment) {
		this.procurementComment = procurementComment;
	}
	public int getUnitId() {
		return unitId;
	}
	public void setUnitId(int unitId) {
		this.unitId = unitId;
	}
	public String getUnitName() {
		return unitName;
	}
	public void setUnitName(String unitName) {
		this.unitName = unitName;
	}
}
