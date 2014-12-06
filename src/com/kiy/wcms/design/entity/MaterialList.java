package com.kiy.wcms.design.entity;

public class MaterialList {
	private int id;
	private int designId;
	private String name;
	private String model;
	private String unitName;
	/**
	 * 理论密度
	 */
	private double density;
	/**
	 * 计算基数
	 */
	private double caculationsBase;
	/**
	 * 单台质量
	 */
	private double singleQuantity;
	/**
	 * 数量
	 */
	private double amount;
	/**
	 * 总质量
	 */
	private double totalQuantity;
	/**
	 * 备注
	 */
	private String remark;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getDesignId() {
		return designId;
	}
	public void setDesignId(int designId) {
		this.designId = designId;
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
	public String getUnitName() {
		return unitName;
	}
	public void setUnitName(String unitName) {
		this.unitName = unitName;
	}
	public double getDensity() {
		return density;
	}
	public void setDensity(double density) {
		this.density = density;
	}
	public double getCaculationsBase() {
		return caculationsBase;
	}
	public void setCaculationsBase(double caculationsBase) {
		this.caculationsBase = caculationsBase;
	}
	public double getSingleQuantity() {
		return singleQuantity;
	}
	public void setSingleQuantity(double singleQuantity) {
		this.singleQuantity = singleQuantity;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public double getTotalQuantity() {
		return totalQuantity;
	}
	public void setTotalQuantity(double totalQuantity) {
		this.totalQuantity = totalQuantity;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
}
