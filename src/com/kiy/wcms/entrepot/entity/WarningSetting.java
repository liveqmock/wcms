package com.kiy.wcms.entrepot.entity;

public class WarningSetting {
	private int id;
	private int goodsId;
	private double quantity;
	
	private String goodsName,goodsModel,goodsBrand;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getGoodsId() {
		return goodsId;
	}
	public void setGoodsId(int goodsId) {
		this.goodsId = goodsId;
	}
	public double getQuantity() {
		return quantity;
	}
	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}
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
}
