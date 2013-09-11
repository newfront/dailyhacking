using System;
using System.Collections;
namespace Trees
{
	class TreeItem
	{
		public TreeItem left;
		public TreeItem right;
		public string name;
		public int cost;
		public bool marked;

		public TreeItem(){}
		public TreeItem(string n){ this.name = n;}
		public TreeItem(string n, int c): this(n) {this.cost = c;}
		public TreeItem(string n, int c, TreeItem l): this(n, c) { this.left = l;}
		public TreeItem(string n, int c, TreeItem l, TreeItem r) : this(n, c, l) {this.right = r;}
	}

	class MainClass
	{
		public static ArrayList search(TreeItem root) {
			// starting at root, we need to search until we get to TreeItem
			ArrayList bfs = new ArrayList ();
			Queue queue = new Queue ();
			root.marked = true;
			queue.Enqueue (root);
			visit (root, ref queue);
			while (queue.Count > 0) {
				TreeItem n = (TreeItem) queue.Dequeue ();
				bfs.Add (n);
				visit (n, ref queue);
			}

			return bfs;

		}

		public static void visit(TreeItem node, ref Queue queue) {
			// check if we have a left or right edge on the node
			if (null != node.left && !node.left.marked) {
				node.left.marked = true;
				queue.Enqueue (node.left);
			}
			if (null != node.right && !node.right.marked) {
				node.right.marked = true;
				queue.Enqueue (node.right);
			}
		}

		public static TreeItem buildTree() {
			/*
			 *             a
			 *        |         |
			 *        b         c
			 *      |        |      |
			 *      d        e      f
			 *    |    |   |    |  |   |
			 *    g    h   h    i  i   j
			 */
			// first node
			TreeItem a = new TreeItem ("a", 5);

			// second, third
			TreeItem b = new TreeItem ("b", 5);
			TreeItem c = new TreeItem ("c", 10);

			a.left = b;
			a.right = c;

			// fourth, fifth, sixth
			TreeItem d = new TreeItem ("d", 6);
			TreeItem e = new TreeItem ("e", 9);
			TreeItem f = new TreeItem ("f", 16);

			b.left = d;

			c.left = e;
			c.right = f;

			// seventh, eighth
			TreeItem g = new TreeItem ("g", 20);
			TreeItem h = new TreeItem ("h", 1);
			TreeItem i = new TreeItem ("i", 2);
			TreeItem j = new TreeItem ("j", 50);

			d.left = g;
			d.right = h;
			e.left = h;
			e.right = i;
			f.left = i;
			f.right = j;

			return a;
		}

		public static void Main (string[] args)
		{
			TreeItem root = buildTree ();
			ArrayList bfs = search(root);
			foreach (TreeItem i in bfs) {
				Console.WriteLine ("TreeItem: (" + i.name + ") distance metric is " + i.cost);

			}
		}
	}
}
