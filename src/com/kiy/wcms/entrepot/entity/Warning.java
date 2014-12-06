package com.kiy.wcms.entrepot.entity;

public class Warning {
	private String goodsName;
	private String goodsModel;
	private String goodsBrand;
	private String goodsUnitName;
	private double warningQuantity;
	private double stockQuantity;
	
	public String getGoodsName() {
		return goodsName;
	}
	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
	}
	public String getGoodsModel() {
		return goodsModel;
	}
	public void setGoodsModel(String goodsModel) {
		this.goodsModel = goodsModel;
	}
	public String getGoodsBrand() {
		return goodsBrand;
	}
	public void setGoodsBrand(String goodsBrand) {
		this.goodsBrand = goodsBrand;
	}
	public String getGoodsUnitName() {
		return goodsUnitName;
	}
	public void setGoodsUnitName(String goodsUnitName) {
		this.goodsUnitName = goodsUnitName;
	}
	public double getWarningQuantity() {
		return warningQuantity;
	}
	public void setWarningQuantity(double warningQuantity) {
		this.warningQuantity = warningQuantity;
	}
	public double getStockQuantity() {
		return stockQuantity;
	}
	public void setStockQuantity(double stockQuantity) {
		this.stockQuantity = stockQuantity;
	}
}
