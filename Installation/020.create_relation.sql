declare
    new_rel_id             relation_type.relation_type_id%type;
    v_checklist_tid        xitor_type.xitor_type_id%type;
    v_checklist_item_tid   xitor_type.xitor_type_id%type;
    
    v_is_in_tree number;
begin
    

    
    select xitor_type_id
    into v_checklist_tid
    from xitor_type
    where upper(XITOR_TYPE) = 'CHECKLIST';
    
    select xitor_type_id
    into v_checklist_item_tid
    from xitor_type
    where upper(XITOR_TYPE) = 'CHECKLISTITEM';
    
    select count(1)
    into v_is_in_tree
    from relation_type 
    where child_type_id = v_checklist_tid
    and rownum = 1;
    
    if v_is_in_tree = 0 then
        new_rel_id := pkg_relation.new_relation_type(pid             => null,
                                                     cid             => v_checklist_tid,
                                                     cardinality     => 2,
                                                     childreqparent  => 1,
                                                     onDeleteCascade => 1,
                                                     uniqueBy        => v_checklist_tid);
        commit;
    end if;
    
    select count(1)
    into v_is_in_tree
    from relation_type 
    where child_type_id = v_checklist_item_tid
    and rownum = 1;
    
    if v_is_in_tree = 0 then
        new_rel_id := pkg_relation.new_relation_type(pid             => v_checklist_tid,
                                                     cid             => v_checklist_item_tid,
                                                     cardinality     => 2,
                                                     childreqparent  => 1,
                                                     onDeleteCascade => 1,
                                                     uniqueBy        => v_checklist_item_tid);
        commit;
    end if;
end;
