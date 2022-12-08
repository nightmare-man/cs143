(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

class Main inherits IO {
   	c:Command;
	s:Stack;
   main() : Object {
      {
	let flag:Bool <-true ,ss:String  in {
		c <- (new Command);
		s <- (new Stack);
		while flag loop {
			out_string(">");
			ss <- in_string();
			flag <- c.parser(ss).exec(s,ss);
		} pool;
		out_string("work has done\n");
		};
	1;
	}
   };

};
class Stack inherits IO {
	len:Int <-0;
	bottom:Node;
	top:Node ;
	null:Node;
	isEmpty():Bool{
		len=0
	};
	top():String{
		top.value()
	};
	print(): Stack{
		{
			let i:Int <- 0,temp:Node <-top in {
				while i < len loop{
					i <- i+1;
					out_string(temp.value());
					out_string("\n");
					temp <- temp.last();
				} pool;
			};
			self;
		}
	};
	push(v:String):Stack{
		{
			let temp : Node <- (new Node).connect(v,null,top) in {
				if isEmpty() then top <- temp else {
					top.connect(top.value(),temp,top.last());
					top <- temp;
				} fi;
			};
			len <- len + 1;
			self;
		}
	};
	pop():String {
		{
			let ret:String in {
				if isEmpty() then ret <- "empty!\n" else{
					len <- len - 1;
					ret <- top.value();
					top <- top.last();
				}fi;	
				ret;
			};
		
		}
	};
};
class Node {
	val : String;
	next : Node;
	last : Node;
	connect(v:String,n:Node,l:Node):Node{
		{
			val <- v;
			next <- n;
			last <- l;
			self;
		}
	};
	value():String{
		val
	};
	next():Node{
		next
	};
	last():Node{
		last
	};
};
class Command inherits A2I{
	parser(s:String):Command{
		{
			let ret:Command in {
				if s="e" then ret <- (new Ecmd) else
				if s="d" then ret <- (new Dcmd) else
				if s="x" then ret <- (new Xcmd) else
				ret <- (new Command) fi fi fi;
				ret;
			};
		}
	};
	exec(s:Stack,v:String):Bool{
		{
	--	(new IO).out_string("push:");
	--	(new IO).out_string(v);
	--	(new IO).out_string("into stack\n");
		s.push(v);true;
		
		}
	};
};
class Ecmd inherits Command{
	exec(s:Stack,v:String):Bool{
		{
			if s.isEmpty() then {(new IO).out_string("e with empty\n");}  else{
				let top:String <- s.top(),top1:String,top2:String in {
				--	(new IO).out_string("e with top:");
				--	(new IO).out_string(top);
				--	(new IO).out_string("\n");
					if top="+" then{
						s.pop();
						top1 <- s.pop();
						top2 <- s.pop();
						s.push(i2a(a2i(top1)+a2i(top2)) );
					}else if top="s" then{
						s.pop();
						top1 <- s.pop();
						top2 <- s.pop();
						s.push(top1);
						s.push(top2);
					}else {
						0;
					} fi fi;
				};
			} fi;
			true;
			
		}
	};	
};
class Dcmd inherits Command{
	exec(s:Stack,v:String):Bool{
		{	s.print();
		
		true;
		}
	};
};
class Xcmd inherits Command{
	exec(s:Stack,v:String):Bool{
		false
	};
};
