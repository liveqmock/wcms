package com.kiy.wcms.order.entity;
/**
 * 订单附件
 * @author Kiy Peng
 * @date 2014年8月22日
 */
public class OrderAtta {
	/**
	 * 主键
	 */
	private int id;
	/**
	 * 订单主键
	 */
	private int orderId;
	/**
	 * 附件路径
	 */
	private String attaPath;
	
	private String fileName;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public String getAttaPath() {
		return attaPath;
	}
	public void setAttaPath(String attaPath) {
		this.attaPath = attaPath;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
}
