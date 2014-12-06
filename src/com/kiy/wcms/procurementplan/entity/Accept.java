package com.kiy.wcms.procurementplan.entity;

public class Accept {
	private int id;
	private int contractDetailId;
	private Double amount;
	private int checkUser;
	private long checkDate;
	private int createUser;
	private long createDate;
	private String remark;
	private int entrepot;
	private int shelf;
	private int goodsId;
	private Double price;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getContractDetailId() {
		return contractDetailId;
	}
	public void setContractDetailId(int contractDetailId) {
		this.contractDetailId = contractDetailId;
	}
	public Double getAmount() {
		return amount;
	}
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	public int getCheckUser() {
		return checkUser;
	}
	public void setCheckUser(int checkUser) {
		this.checkUser = checkUser;
	}
	public long getCheckDate() {
		return checkDate;
	}
	public void setCheckDate(long checkDate) {
		this.checkDate = checkDate;
	}
	public int getCreateUser() {
		return createUser;
	}
	public void setCreateUser(int createUser) {
		this.createUser = createUser;
	}
	public long getCreateDate() {
		return createDate;
	}
	public void setCreateDate(long createDate) {
		this.createDate = createDate;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public int getEntrepot() {
		return entrepot;
	}
	public void setEntrepot(int entrepot) {
		this.entrepot = entrepot;
	}
	public int getShelf() {
		return shelf;
	}
	public void setShelf(int shelf) {
		this.shelf = shelf;
	}
	public int getGoodsId() {
		return goodsId;
	}
	public void setGoodsId(int goodsId) {
		this.goodsId = goodsId;
	}
	public Double getPrice() {
		return price;
	}
	public void setPrice(Double price) {
		this.price = price;
	}
	
}
