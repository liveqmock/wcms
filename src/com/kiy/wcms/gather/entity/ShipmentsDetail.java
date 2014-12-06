package com.kiy.wcms.gather.entity;

public class ShipmentsDetail {
	private int id;
	private int shipmentsId;
	private int orderDetailId;
	private String unit;
	private double amount;
	private String name;
	private String model;
	private String unitName;
	
	private String orderDetailName;
	/**
	 * 订单明细物品数量
	 */
	private double orderDetailQuantity;
	/**
	 * 已申请发货数量
	 */
	private double hadAmount;
	/**
	 * 剩余申请发货数量
	 */
	private double surplusAmount;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getShipmentsId() {
		return shipmentsId;
	}
	public void setShipmentsId(int shipmentsId) {
		this.shipmentsId = shipmentsId;
	}
	public int getOrderDetailId() {
		return orderDetailId;
	}
	public void setOrderDetailId(int orderDetailId) {
		this.orderDetailId = orderDetailId;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public String getOrderDetailName() {
		return orderDetailName;
	}
	public void setOrderDetailName(String orderDetailName) {
		this.orderDetailName = orderDetailName;
	}
	public double getOrderDetailQuantity() {
		return orderDetailQuantity;
	}
	public void setOrderDetailQuantity(double orderDetailQuantity) {
		this.orderDetailQuantity = orderDetailQuantity;
	}
	public double getHadAmount() {
		return hadAmount;
	}
	public void setHadAmount(double hadAmount) {
		this.hadAmount = hadAmount;
	}
	public double getSurplusAmount() {
		return surplusAmount;
	}
	public void setSurplusAmount(double surplusAmount) {
		this.surplusAmount = surplusAmount;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
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
}
