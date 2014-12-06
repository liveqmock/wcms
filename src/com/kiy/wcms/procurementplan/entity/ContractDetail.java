package com.kiy.wcms.procurementplan.entity;
/**
 * 采购订单明细
 * @author wuwenlong
 * @date 2014年10月01日
 */
public class ContractDetail {
	/**
	 * 主键
	 */
	private int id;
	/**
	 * 采购订单ID
	 */
	private int contractId;
	/**
	 * 采购计划ID
	 */
	private Integer planId;
	/**
	 * 数量
	 */
	private int amount;
	/**
	 * 单价
	 */
	private double unitPrice;
	/**
	 * 总金额
	 */
	private double dSum;
	/**
	 * 备注
	 */
	private String remark;
	/**
	 * 物品名称
	 */
	private String name;
	/**
	 * 规格型号
	 */
	private String model;
	/**
	 * 品牌
	 */
	private String brand;
	/**
	 * 用途
	 */
	private String purpose;
	/**
	 * 单位
	 */
	private String unit;
	
	private int goodsId;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getContractId() {
		return contractId;
	}
	public void setContractId(int contractId) {
		this.contractId = contractId;
	}
	public Integer getPlanId() {
		return planId;
	}
	public void setPlanId(Integer planId) {
		this.planId = planId;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	public double getUnitPrice() {
		return unitPrice;
	}
	public void setUnitPrice(double unitPrice) {
		this.unitPrice = unitPrice;
	}
	public double getdSum() {
		return dSum;
	}
	public void setdSum(double dSum) {
		this.dSum = dSum;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
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
	public String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}
	public String getPurpose() {
		return purpose;
	}
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	public int getGoodsId() {
		return goodsId;
	}
	public void setGoodsId(int goodsId) {
		this.goodsId = goodsId;
	}
}
