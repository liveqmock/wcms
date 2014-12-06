package com.kiy.wcms.util;


public class PageView {
	private int total;
	private Object rows;
	
	public PageView(int total, Object obj) {
		this.total = total;
		this.rows = obj;
	}
	
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	public Object getRows() {
		return rows;
	}
	public void setRows(Object rows) {
		this.rows = rows;
	}
}
