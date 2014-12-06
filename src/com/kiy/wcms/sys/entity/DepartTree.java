package com.kiy.wcms.sys.entity;

import java.util.List;

public class DepartTree {
	private int id;
	private String text;
	private List<DepartTree> children;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public List<DepartTree> getChildren() {
		return children;
	}
	public void setChildren(List<DepartTree> children) {
		this.children = children;
	}
}
