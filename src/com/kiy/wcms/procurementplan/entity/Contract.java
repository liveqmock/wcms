package com.kiy.wcms.procurementplan.entity;

public class Contract {
	private int id;
	private String code;
	private String name;
	private String supplier;
	private long signDate;
	private String signDateStr;
	private int signUser;
	private String signUserName;
	private double sum;
	private double hadPay;
	private double unPay;
	private double hadBill;
	private double unBill;
	
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
	public String getSupplier() {
		return supplier;
	}
	public void setSupplier(String supplier) {
		this.supplier = supplier;
	}
	public long getSignDate() {
		return signDate;
	}
	public void setSignDate(long signDate) {
		this.signDate = signDate;
	}
	public String getSignDateStr() {
		return signDateStr;
	}
	public void setSignDateStr(String signDateStr) {
		this.signDateStr = signDateStr;
	}
	public int getSignUser() {
		return signUser;
	}
	public void setSignUser(int signUser) {
		this.signUser = signUser;
	}
	public String getSignUserName() {
		return signUserName;
	}
	public void setSignUserName(String signUserName) {
		this.signUserName = signUserName;
	}
	public double getSum() {
		return sum;
	}
	public void setSum(double sum) {
		this.sum = sum;
	}
	public double getHadPay() {
		return hadPay;
	}
	public void setHadPay(double hadPay) {
		this.hadPay = hadPay;
	}
	public double getUnPay() {
		return unPay;
	}
	public void setUnPay(double unPay) {
		this.unPay = unPay;
	}
	public double getHadBill() {
		return hadBill;
	}
	public void setHadBill(double hadBill) {
		this.hadBill = hadBill;
	}
	public double getUnBill() {
		return unBill;
	}
	public void setUnBill(double unBill) {
		this.unBill = unBill;
	}
	
}
