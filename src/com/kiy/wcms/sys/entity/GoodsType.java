package com.kiy.wcms.sys.entity;

import java.util.List;

//物品类别
public class GoodsType {
	private Integer id;
	private String text;
	private Integer pid;
	private List<GoodsType> children;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public Integer getPid() {
		return pid;
	}
	public void setPid(Integer pid) {
		this.pid = pid;
	}
	public List<GoodsType> getChildren() {
		return children;
	}
	public void setChildren(List<GoodsType> children) {
		this.children = children;
	}
}
