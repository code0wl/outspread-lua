function beginContact(a, b, coll)
    if (a:getUserData() == 'Spider' and b:getUserData() == 'Ant') then
        print('spider attacked ant')
    end
end
