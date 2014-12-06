package com.kiy.wcms.procurementplan.entity;
/**
 * 采购计划明细参数
 * @author wuwenlong
 * @date 2014年9月21日
 */
public class ProcurementDetailParam {
	/**
	 * 起始页标
	 */
	private int begin;
	/**
	 * 每页显示条数
	 */
	private int rows;
	/**
	 * 主键
	 */
	private int id;
	/**
	 * 外键：采购计划ID
	 */
	private int planId;
	/**
	 * 采购编号
	 */
	private String code;
	
	/**
	 * 计划人编码
	 */
	private String applyUser;
	/**
	 * 提报日期
	 */
	private String applyDate;
	/**
	 * 计划日期起
	 */
	private String applyDateBegin;
	/**
	 * 计划日期止
	 */
	private String applyDateEnd;
	/**
	 * 计划人
	 */
	private String applyUserName;
	/**
	 * 名称
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
	 * 数量
	 */
	private Integer amount;
	/**
	 * 单位编号
	 */
	private int unitId;
	/**
	 * 单位名称
	 */
	private String unitName;
	/**
	 * 单价
	 */
	private Double unitPrice;
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
	public Integer getAmount() {
		return amount;
	}
	public void setAmount(Integer amount) {
		this.amount = amount;
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
	public Double getUnitPrice() {
		return unitPrice;
	}
	public void setUnitPrice(Double unitPrice) {
		this.unitPrice = unitPrice;
	}
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
	public int getBegin() {
		return begin;
	}
	public void setBegin(int begin) {
		this.begin = begin;
	}
	public int getRows() {
		return rows;
	}
	public void setRows(int rows) {
		this.rows = rows;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getApplyUser() {
		return applyUser;
	}
	public void setApplyUser(String applyUser) {
		this.applyUser = applyUser;
	}
	public String getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}
	public String getApplyDateBegin() {
		return applyDateBegin;
	}
	public void setApplyDateBegin(String applyDateBegin) {
		this.applyDateBegin = applyDateBegin;
	}
	public String getApplyDateEnd() {
		return applyDateEnd;
	}
	public void setApplyDateEnd(String applyDateEnd) {
		this.applyDateEnd = applyDateEnd;
	}
	public String getApplyUserName() {
		return applyUserName;
	}
	public void setApplyUserName(String applyUserName) {
		this.applyUserName = applyUserName;
	}
}
