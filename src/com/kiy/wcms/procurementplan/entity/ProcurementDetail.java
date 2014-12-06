package com.kiy.wcms.procurementplan.entity;
/**
 * 采购计划明细
 * @author wuwenlong
 * @date 2014年9月21日
 */
public class ProcurementDetail {
	/**
	 * 主键
	 */
	private int id;
	/**
	 * 外键：采购计划ID
	 */
	private int planId;
//	/**
//	 * 名称
//	 */
//	private String name;
//	/**
//	 * 规格型号
//	 */
//	private String model;
//	/**
//	 * 品牌
//	 */
//	private String brand;
	/**
	 * 用途
	 */
	private String purpose;
	/**
	 * 数量
	 */
	private int amount;
//	/**
//	 * 单位
//	 */
//	private int unit;
//	/**
//	 * 单价
//	 */
//	private double unitPrice;
	/**
	 * 预算金额
	 */
	private String budgetSum;
	/**
	 * 期望到货日期
	 */
	private String expectArrivalDate;
	/**
	 * 备注
	 */
	private String remark;
	/**
	 * 物品ID
	 */
	private int goodsId;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getPlanId() {
		return planId;
	}
	public void setPlanId(int planId) {
		this.planId = planId;
	}
//	public String getName() {
//		return name;
//	}
//	public void setName(String name) {
//		this.name = name;
//	}
//	public String getModel() {
//		return model;
//	}
//	public void setModel(String model) {
//		this.model = model;
//	}
//	public String getBrand() {
//		return brand;
//	}
//	public void setBrand(String brand) {
//		this.brand = brand;
//	}
	public String getPurpose() {
		return purpose;
	}
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
//	public int getUnit() {
//		return unit;
//	}
//	public void setUnit(int unit) {
//		this.unit = unit;
//	}
//	public double getUnitPrice() {
//		return unitPrice;
//	}
//	public void setUnitPrice(double unitPrice) {
//		this.unitPrice = unitPrice;
//	}
	public String getBudgetSum() {
		return budgetSum;
	}
	public void setBudgetSum(String budgetSum) {
		this.budgetSum = budgetSum;
	}
	public String getExpectArrivalDate() {
		return expectArrivalDate;
	}
	public void setExpectArrivalDate(String expectArrivalDate) {
		this.expectArrivalDate = expectArrivalDate;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public int getGoodsId() {
		return goodsId;
	}
	public void setGoodsId(int goodsId) {
		this.goodsId = goodsId;
	}
	
}
