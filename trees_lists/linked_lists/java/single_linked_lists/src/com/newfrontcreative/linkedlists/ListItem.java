package com.newfrontcreative.linkedlists;

public class ListItem {
	/**
	 * Instance Variables
	 */
	public int data;
	public ListItem next;
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("here we go");
	}

	public ListItem(int dData)
	{
		data = dData;
	}

	public void setNext(ListItem item)
	{
		next = item;
	}

	public ListItem getNext()
	{
		return next;
	}

	public int getData()
	{
		return data;
	}

}
