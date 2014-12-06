package com.kiy.wcms.entrepot.entity;
//货架号
public class Shelf {
	private Integer id;
	private Integer entrepotId;
	private String name;
	private String code;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getEntrepotId() {
		return entrepotId;
	}
	public void setEntrepotId(Integer entrepotId) {
		this.entrepotId = entrepotId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	
}
