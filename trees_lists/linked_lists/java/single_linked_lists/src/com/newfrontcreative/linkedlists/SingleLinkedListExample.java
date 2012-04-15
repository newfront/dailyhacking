package com.newfrontcreative.linkedlists;

public class SingleLinkedListExample {
	// Instance Variables
	public static List list;
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// instantiate a new list
		list = new List(new ListItem(3)); // sets head's data to 3

		System.out.println("head is: " + list.head().getData()); // 3

		// tail should be 3
		System.out.println("tail is: " + list.tail().getData());

		// insert a new head for the list
		list.insertAtFront(new ListItem(2)); // sets head's data to 2
		System.out.println("head is now: " + list.head().getData()); // 2

		// insert a tail (since it is the first time, it should capture the current
		list.insertAtEnd(new ListItem(15)); // tail is 15

		System.out.println("tail is now: " + list.tail().getData()); //15

		// view some data on the list
		System.out.println(list.toString());

		// get the length of the list
		System.out.println("length: " + list.length());

		// get the max value of the list
		System.out.println("max: " + list.max());

		// get the min value of the list
		System.out.println("min: " + list.min());

		// Example Iterator method on Single Linked List
		ListItem cur = list.head();
		for (int i = 0; i < list.length(); i++) {
			System.out.println(cur.getData());
			cur = cur.getNext();
		}

		// remove item
		System.out.println("going to shift");
		// 2, 3, 15
		System.out.println(list.shift()); //2
		System.out.println(list.length()); //2
		// remove item
		System.out.println("tail: " + list.tail().getData()); //15
		System.out.println("--------------- list.pop ----------");
		System.out.println(list.pop().getData()); // find last...
		System.out.println("tail: " + list.tail().getData()); // 3
		// remove item
		System.out.println("--------------- list.pop 2----------");
		System.out.println("list: " + list.pop()); // nothing left //null
		// insert item
		System.out.println("---------------- missing pop above -----");
		System.out.println("length: " + list.length());
		list.insertAtFront(new ListItem(13)); // min, max = 13
		System.out.println(list.length());
		System.out.println("max: " + list.max() + " min: " + list.min()); // 13
		list.insertAtFront(new ListItem(255)); // min: 13, max: 255
		System.out.println(list.length());
		System.out.println("max: " + list.max() + " min: " + list.min()); 
		list.insertAtEnd(new ListItem(2453)); // min: 13, max: 2453
		System.out.println(list.length());
		System.out.println("max: " + list.max() + " min: " + list.min());
		list.insertAtEnd(new ListItem(99));
		System.out.println(list.length());
		// remove the second item from the list, and then iterate over items
		System.out.println("head: " + list.head().getData());

		// see the hash before removing an item
		System.out.println("-------- List ----------");
		cur = list.head();
		for (int i = 0; i < list.length(); i++) {
			System.out.println("list["+i+"] = " + cur.getData());
			cur = cur.getNext();
		}
		System.out.println("-------- List ----------");
		list.remove(list.head().getNext());

		cur = list.head();
		for (int i = 0; i < list.length(); i++) {
			System.out.println("list["+i+"] = " + cur.getData());
			cur = cur.getNext();
		}

	}

}
