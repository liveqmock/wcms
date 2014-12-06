package com.kiy.wcms.gather.entity;

public class GatherAtta {
	private int id;
	private int gatherId;
	private String filePath;
	private String fileName;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getGatherId() {
		return gatherId;
	}
	public void setGatherId(int gatherId) {
		this.gatherId = gatherId;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
}
