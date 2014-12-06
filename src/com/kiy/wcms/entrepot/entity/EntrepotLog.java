package com.kiy.wcms.entrepot.entity;

//出入库登记
public class EntrepotLog {
	private int id;
	private String code;
	private double amount;
	private double unitPrice;
	private String remark;
	private int type;//0:入库  1:出库
	private int entrepotId;
	private String entrepotName;
	private int shelfId;
	private String shelfName;
	private Integer receiveUserId;
	private String receiveUserName;
	private int createUser;
	
	private long createTime;
	private String createTimeStr;
	
	private int goodsId;
	private String goodsName;
	private String goodsModel;
	private String goodsBrand;
	private String goodsUnitName;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public double getUnitPrice() {
		return unitPrice;
	}
	public void setUnitPrice(double unitPrice) {
		this.unitPrice = unitPrice;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public int getEntrepotId() {
		return entrepotId;
	}
	public void setEntrepotId(int entrepotId) {
		this.entrepotId = entrepotId;
	}
	public String getEntrepotName() {
		return entrepotName;
	}
	public void setEntrepotName(String entrepotName) {
		this.entrepotName = entrepotName;
	}
	public int getShelfId() {
		return shelfId;
	}
	public void setShelfId(int shelfId) {
		this.shelfId = shelfId;
	}
	public String getShelfName() {
		return shelfName;
	}
	public void setShelfName(String shelfName) {
		this.shelfName = shelfName;
	}
	public Integer getReceiveUserId() {
		return receiveUserId;
	}
	public void setReceiveUserId(Integer receiveUserId) {
		this.receiveUserId = receiveUserId;
	}
	public String getReceiveUserName() {
		return receiveUserName;
	}
	public void setReceiveUserName(String receiveUserName) {
		this.receiveUserName = receiveUserName;
	}
	public int getCreateUser() {
		return createUser;
	}
	public void setCreateUser(int createUser) {
		this.createUser = createUser;
	}
	public int getGoodsId() {
		return goodsId;
	}
	public void setGoodsId(int goodsId) {
		this.goodsId = goodsId;
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
	public long getCreateTime() {
		return createTime;
	}
	public void setCreateTime(long createTime) {
		this.createTime = createTime;
	}
	public String getCreateTimeStr() {
		return createTimeStr;
	}
	public void setCreateTimeStr(String createTimeStr) {
		this.createTimeStr = createTimeStr;
	}
}
