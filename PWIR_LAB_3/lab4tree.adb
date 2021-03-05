with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

with Ada.Strings.Fixed, Ada.Containers.Vectors;
use  Ada.Strings.Fixed, Ada.Containers;

procedure Lab4Tree is

type Tree is record
    Data: Integer;
    Right: access Tree := Null;
    Left: access Tree := Null;
end record;

type TreePtr is access all Tree;

procedure Insert(root: in out TreePtr; N: Integer) is
    current: TreePtr := root;
    Node: TreePtr := new Tree;
begin
    Node.Data := N;
    if root = Null then
        root := Node;
    else 
        if current.Data < N then
            if current.Right = Null then
                current.Right := Node;
            else
                current := current.Right;
                Insert(current,N);
            end if;
        else
            if current.Left = Null then
                current.Left := Node;
            else
                current := current.Left;
                Insert(current,N);
            end if;
        end if;
    end if;
end Insert;


procedure PrintNode(root:TreePtr; spaces: in out Integer) is
    space_const_number : constant Integer := 6;
begin
    if root = Null then
        null;
    else
        spaces := spaces + space_const_number;
        PrintNode(root.Right,spaces);
        
        New_Line;
        for I in space_const_number..spaces loop
            Put(" ");
        end loop;
        Put_Line(root.Data'Img&"<");
        
        PrintNode(root.Left,spaces);
        spaces := spaces - space_const_number;

    end if;
end PrintNode;

procedure Print(root:TreePtr) is
x:Integer:=0;
begin
    PrintNode(root,x);
end Print;



procedure addRandom(root: in out TreePtr; N,M:Integer) is
    package rnd is new Ada.Numerics.Discrete_Random(Integer);
    use rnd;
    Gen: Generator;
    Random_number: Integer;
    i:Integer:=0;
begin
    Reset(Gen);
    while i<N loop
        Random_number:= Random(Gen) mod M;
        Insert(root,Random_number);
        i:=i+1;
    end loop;
end addRandom;

function Search(root:TreePtr;N:Integer) return Boolean is
begin
    if root = Null then
        return False;
    else
        return (root.Data = N or Search(root.Right,N) or Search(root.Left,N));
    end if;
end Search;

function TreeSuccessor(Tree: in out TreePtr) return TreePtr is
    L: TreePtr := Tree;
begin
    while L.Left /= Null loop
        L := L.Left;
    end loop;
    return L;
end TreeSuccessor;

function DeleteNode (Tree: in out TreePtr; N: in Integer) return TreePtr is
Temp: TreePtr := null;
Root: TreePtr := Tree;
begin
    if Root = null then 
        return Root; 
    end if;

    if N < Root.Data then 
        Root.Left := deleteNode(Root.Left, N);
    elsif N > Root.Data then
        Root.Right := deleteNode(Root.Right, N);
    else
        if Root.Left = null then
            return Root.Right;
        elsif Root.Right = null then
            return Root.Left;
        end if;

        Temp := TreeSuccessor(Root.Right);
        Root.Data := Temp.Data;
        Root.Right := deleteNode(Root.Right,Temp.Data);

    end if;
    return root;
end DeleteNode;

procedure Delete(Tree: in out TreePtr; N: in Integer) is
begin
    Tree := DeleteNode(Tree,N);
end Delete;












package Float_Container is new Vectors(Natural,Integer);    
use Float_Container;

function getNodes(Tree: in TreePtr) return Vector is
    vectorFromTree: Vector;
begin
    if Tree /= Null then
        Append(vectorFromTree, getNodes(Tree.Left));
        Append(vectorFromTree, Tree.Data);
        Append(vectorFromTree, getNodes(Tree.Right));
    end if;
   return vectorFromTree;
end getNodes;

procedure balanceStep(Trees: in out TreePtr; Nodes: in out Vector; First: in Integer; Last: in Integer) is
newTree: TreePtr := new Tree;
center_index: Integer;
begin
    Trees := newTree;
    center_index:= Integer((Last+First+1)/2);

    newTree.Data := Nodes(center_index);

    if (center_index-1 >= First) then
        balanceStep(newTree.Left, Nodes, First, center_index-1);
    end if;
    if (Last >= center_index+1) then
        balanceStep(newTree.Right, Nodes, center_index+1, Last);
    end if;
end balanceStep;

procedure balanceTree(Tree: in out TreePtr) is
    vectorFromTree: Vector := getNodes(Tree);
begin
    balanceStep(Tree,vectorFromTree,0,Integer(Length(vectorFromTree)-1));
end balanceTree;


function Serialize(Tree: in out TreePtr) return String is
begin
    if Tree /= Null then
        return "{" 
        & """data"":""" & Ada.Strings.Fixed.Trim(Tree.Data'Image, Ada.Strings.Left) 
        & """,""left"":" & Serialize(Tree.Left)
        & ",""right"":" & Serialize(Tree.Right) 
        & "}";
    else
        return "null";
    end if;
end Serialize;

procedure Save(Tree: in TreePtr) is
    Utfile        : File_Type;
begin
    Create(Utfile, Out_File, "tree.json");
    Put_Line(Utfile, Serialize(Tree));
    Close(Utfile);
end Save;



Drzewo1: TreePtr:= Null; 
Drzewo2: TreePtr:= Null; 
begin
    Insert(Drzewo1,15);
    Insert(Drzewo1,10);
    Insert(Drzewo1,20);
    Insert(Drzewo1,12);
    Insert(Drzewo1,17);
    Insert(Drzewo1,5);
    Insert(Drzewo1,30);
    Print(Drzewo1);
    New_Line(15);
    Delete(Drzewo1,30);
    Print(Drzewo1);
   
    
    -- Put_Line("####### nowe drzewo #######");
    -- addRandom(Drzewo2,8,20);
    -- Print(Drzewo2);

    -- Put_Line(Search(Drzewo1,17)'Img);
    
    
end Lab4Tree;


-- procedure Delete(Tree: in out TreePtr; N: in Integer) is
--     previousNode: TreePtr := null;
--     nodeToDelete: TreePtr := Tree;
--     minFromRight: TreePtr := null;
-- begin
--     -- find Node to delete
--     while nodeToDelete /= null and then nodeToDelete.Data /= N loop
--         if N < nodeToDelete.Data then
--             nodeToDelete := nodeToDelete.Left;
--         else
--             Put_Line("ide w prawio");
--             nodeToDelete := nodeToDelete.Right;
--         end if;   
--     end loop;
--      Put_line("XD" & nodeToDelete.Parent.Data'Image & "XD" & nodeToDelete.Data'Image);

--     -- removing nodeToDelete from Tree
--     if nodeToDelete /= null then
--         --one node or zero
--         if nodeToDelete.Right = null then
--             Put_line("a");
--             Put_line("XD" & nodeToDelete.Parent.Data'Image & "XD" & nodeToDelete.Data'Image);
--             if nodeToDelete.Parent.Right = nodeToDelete then
--                 nodeToDelete.Parent.Right := nodeToDelete.Left;

--             elsif nodeToDelete.Parent.Left = nodeToDelete then
--                 nodeToDelete.Parent.Left := nodeToDelete.Left;
--             end if;
--         elsif nodeToDelete.Left = null then
--             Put_line("b");
--             if nodeToDelete.Parent.Right = nodeToDelete then
--                 nodeToDelete.Parent.Right := nodeToDelete.Right;
--             elsif nodeToDelete.Parent.Left = nodeToDelete then
--                 nodeToDelete.Parent.Left := nodeToDelete.Right;
--             end if;
--         else -- two nodes
--             minFromRight := nodeToDelete.Right;
--             while minFromRight.Left /= Null loop
--                 minFromRight := minFromRight.Left;
--             end loop; 
--             nodeToDelete.Data := minFromRight.Data;
--             Put_Line("USUWAM");
--             Delete(nodeToDelete.Right, minFromRight.Data);
--         end if;
--     end if;
-- end Delete;