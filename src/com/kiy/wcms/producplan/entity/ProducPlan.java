package com.kiy.wcms.producplan.entity;

import com.kiy.wcms.order.entity.Order;

public class ProducPlan {
	private int id;
	private Order order;
	private String productionComment;
	private String sailComment;
	private int status;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getProductionComment() {
		return productionComment;
	}
	public void setProductionComment(String productionComment) {
		this.productionComment = productionComment;
	}
	public String getSailComment() {
		return sailComment;
	}
	public void setSailComment(String sailComment) {
		this.sailComment = sailComment;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public Order getOrder() {
		return order;
	}
	public void setOrder(Order order) {
		this.order = order;
	}
}
