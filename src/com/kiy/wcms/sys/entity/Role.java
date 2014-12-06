package com.kiy.wcms.sys.entity;

public class Role {
	private int id;
	private String code;
	private String name;
	private String sdesc;
	private boolean isHas;
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSdesc() {
		return sdesc;
	}
	public void setSdesc(String sdesc) {
		this.sdesc = sdesc;
	}
	public boolean getIsHas() {
		return isHas;
	}
	public void setIsHas(boolean isHas) {
		this.isHas = isHas;
	}
	
}
