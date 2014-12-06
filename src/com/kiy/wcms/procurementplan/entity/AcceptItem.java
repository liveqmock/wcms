package com.kiy.wcms.procurementplan.entity;

public class AcceptItem {
	private Integer contractDetailId;
	private Integer contractId;
	private String applyNo;
	private String goodsName;
	private String model;
	private String brand;
	private String supply;
	private String unitName;
	private String arriveDate;
	private Integer goodsId;
	private Double price;
	/**
	 * 购买数量,已到货数量,未到货数量
	 */
	private Double amount,receive,unReceive;
	
	public Integer getContractDetailId() {
		return contractDetailId;
	}
	public void setContractDetailId(Integer contractDetailId) {
		this.contractDetailId = contractDetailId;
	}
	public Integer getContractId() {
		return contractId;
	}
	public void setContractId(Integer contractId) {
		this.contractId = contractId;
	}
	public String getApplyNo() {
		return applyNo;
	}
	public void setApplyNo(String applyNo) {
		this.applyNo = applyNo;
	}
	public String getGoodsName() {
		return goodsName;
	}
	public void setGoodsName(String goodsName) {
		this.goodsName = goodsName;
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
	public String getSupply() {
		return supply;
	}
	public void setSupply(String supply) {
		this.supply = supply;
	}
	public String getUnitName() {
		return unitName;
	}
	public void setUnitName(String unitName) {
		this.unitName = unitName;
	}
	public String getArriveDate() {
		return arriveDate;
	}
	public void setArriveDate(String arriveDate) {
		this.arriveDate = arriveDate;
	}
	public Integer getGoodsId() {
		return goodsId;
	}
	public void setGoodsId(Integer goodsId) {
		this.goodsId = goodsId;
	}
	public Double getAmount() {
		return amount;
	}
	public void setAmount(Double amount) {
		this.amount = amount;
	}
	public Double getReceive() {
		return receive;
	}
	public void setReceive(Double receive) {
		this.receive = receive;
	}
	public Double getUnReceive() {
		return unReceive;
	}
	public void setUnReceive(Double unReceive) {
		this.unReceive = unReceive;
	}
	public Double getPrice() {
		return price;
	}
	public void setPrice(Double price) {
		this.price = price;
	}
}
