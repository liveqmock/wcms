package com.kiy.wcms.entrepot.entity;

public class EntrepotParam {
	private Integer begin;
	private Integer rows;
	
	private String code,model,name,brand,createDateStrBegin,createDateStrEnd,receiveUserName;
	private Integer receiveUser;
	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}
	public String getCreateDateStrBegin() {
		return createDateStrBegin;
	}
	public void setCreateDateStrBegin(String createDateStrBegin) {
		this.createDateStrBegin = createDateStrBegin;
	}
	public String getCreateDateStrEnd() {
		return createDateStrEnd;
	}
	public void setCreateDateStrEnd(String createDateStrEnd) {
		this.createDateStrEnd = createDateStrEnd;
	}
	public Integer getReceiveUser() {
		return receiveUser;
	}
	public void setReceiveUser(Integer receiveUser) {
		this.receiveUser = receiveUser;
	}
	public Integer getBegin() {
		return begin;
	}
	public void setBegin(Integer begin) {
		this.begin = begin;
	}
	public Integer getRows() {
		return rows;
	}
	public void setRows(Integer rows) {
		this.rows = rows;
	}
	public String getReceiveUserName() {
		return receiveUserName;
	}
	public void setReceiveUserName(String receiveUserName) {
		this.receiveUserName = receiveUserName;
	}
}
