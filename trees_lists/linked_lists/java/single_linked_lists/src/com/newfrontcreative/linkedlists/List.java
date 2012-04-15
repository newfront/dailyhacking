package com.newfrontcreative.linkedlists;

public class List {
	/**
	 * Instance Variables
	 */
	public ListItem head;
	public ListItem tail;
	public long length;
	public long max;
	public long min;

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("sweet - list");
	}

	public List(ListItem lHead)
	{
		head = lHead;
		// set variables directly
		length = 1;
		max = head.getData();
		min = max;
	}

	// add a new ListItem at the front of the list
	public void insertAtFront(ListItem nItem)
	{
		ListItem old = head;
		head = nItem;
		head.setNext(old);

		if (tail == null)
			tail = old;

		// set max, set min
		this.setMax(head.getData());
		this.setMin(head.getData());

		length += 1; // increment the internal length counter
	}

	// add a new ListItem to the end of the list
	public void insertAtEnd(ListItem nItem)
	{
		ListItem lastTail;
		lastTail = this.tail();
		tail = nItem;
		lastTail.setNext(tail);

		this.setMax(tail.getData());
		this.setMin(tail.getData());
		length += 1; // increment the internal length counter
	}

	// set the head
	public void setHead(ListItem nHead)
	{
		head = nHead;
	}

	// return the current head
	public ListItem head()
	{
		return head;
	}

	// set the tail
	public void setTail(ListItem nTail)
	{
		tail = nTail;
	}

	// return the current tail
	public ListItem tail()
	{
		if (tail == null)
			tail = head;
		return tail;
	}

	// remove first item
	public ListItem shift()
	{
		// save in memory
		ListItem first = this.head();

		// reset head to next item, or null if no next item
		if (first.getNext() == null)
		{
			this.setHead(null);
		} else {
			this.setHead(first.getNext());
		}

		length -= 1; // decrement by one prior to testing for new MinMax

		this.updateMinMax();


		return first;
	}

	// remove last item
	public ListItem pop()
	{
		// save last item in memory
		ListItem last = this.tail();
		ListItem pointer = this.getLinkingItem(last);

		if (pointer != null)
		{
			this.setTail(pointer);
			length -= 1; // decrement by one prior to testing for new MinMax
			this.updateMinMax();
			System.out.println("List::length : " + this.length());
			System.out.println(pointer);
			return last;
		} else {
			length -= 1; // decrement by one prior to testing for new MinMax
			System.out.println("List::length (pointer is null): " + this.length());
			head = null;
			tail = null;
			max = 0;
			min = -1;
		}

		return last;
	}

	// remove an element from the list
	public void remove(ListItem target)
	{
		System.out.println("Remove: " + target.getData() + " from the list");
		// iterate through the list until the target is reached
		ListItem beforeTarget = this.getLinkingItem(target);
		ListItem afterTarget = target.getNext();

		System.out.println("target: " + target.getData());
		System.out.println("before target: " + beforeTarget.getData());
		System.out.println("after target: " + afterTarget.getData());
		beforeTarget.setNext(afterTarget);
		length -= 1;
		this.updateMinMax();
	}

	// will return the ListItem linking to target
	public ListItem getLinkingItem(ListItem target)
	{
		// start with head
		ListItem cur = this.head();
		for (int i=0; i < this.length(); i++)
		{
			if (cur.getNext() == target)
				return cur;
			cur = cur.getNext();
		}
		return null;
	}

	// find min, max
	public void updateMinMax()
	{
		if (this.length() == 1) {
			// if there is only one value, set it for both max and min
			this.setMax(this.head().getData());
			min = -1;
			System.out.println("min: " + this.min());
		} else {
			// start with head
			ListItem cur = this.head();
			for (int i=0; i < this.length(); i++)
			{
				if (cur == null)
					break;

				this.setMin(cur.getData());
				this.setMax(cur.getData());
				cur = cur.getNext();
			}
		}
	}

	// iterator helpers
	public ListItem next(ListItem pointer)
	{
		return pointer.getNext();
	}

	// set the value of max
	public void setMax(int nMax)
	{
		if (nMax >= 0) {
			long m = (long) nMax;
			if (max < m)
				max = m;
		}
	}
	// get the value of max
	public long max()
	{
		return max;
	}
	// set the value of min
	public void setMin(int nMin)
	{
		if (nMin > 0)
		{
			long m = (long) nMin;
			if (min == -1) {
				min = m;
			} else if (min > m)
				min = m;
		}
	}
	// get the value of min
	public long min()
	{
		return min;
	}

	// get the current list length
	public long length() {
		return length;
	}

	// helper method (toString)
	public String toString()
	{
		return "The List has " + this.length() + " elements.\nThe head is set to value of " + this.head().getData() + "\nThe tail is set to " + this.tail().getData() + "";
	}

}
