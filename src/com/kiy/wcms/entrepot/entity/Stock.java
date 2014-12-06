package com.kiy.wcms.entrepot.entity;
//库存表
public class Stock {
	private int goodsId;
	private int entrepotId;
	private int shelfId;
	private double quantity;
	
	private String goodsName;
	private String goodsModel;
	private String goodsBrand;
	private String goodsUnitName;
	private String entrepotName;
	private String shelfName;
	
	private String remark;
	
	public int getGoodsId() {
		return goodsId;
	}
	public void setGoodsId(int goodsId) {
		this.goodsId = goodsId;
	}
	public int getEntrepotId() {
		return entrepotId;
	}
	public void setEntrepotId(int entrepotId) {
		this.entrepotId = entrepotId;
	}
	public int getShelfId() {
		return shelfId;
	}
	public void setShelfId(int shelfId) {
		this.shelfId = shelfId;
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
	public String getGoodsUnitName() {
		return goodsUnitName;
	}
	public void setGoodsUnitName(String goodsUnitName) {
		this.goodsUnitName = goodsUnitName;
	}
	public String getEntrepotName() {
		return entrepotName;
	}
	public void setEntrepotName(String entrepotName) {
		this.entrepotName = entrepotName;
	}
	public String getShelfName() {
		return shelfName;
	}
	public void setShelfName(String shelfName) {
		this.shelfName = shelfName;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
}
