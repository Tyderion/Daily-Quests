# Daily Quests
This will be an application where you can do the following features:
- Be remembered to do something (a Quest) at a (more or less) convenient time of the day
- Have lists with items in it and when there is not enough of an item, it will make a Quest for you to get this item.
- Users can only see their own lists or lists they've been invited to or public lists.
- Users can select from all public Items that are in the database.
- Items, Tasks and Lists can be created as private or public.
- a task has 0 to many tasks -> a task is like a tree with variable number of child-tasks at every element
- a task cannot have itself or any of its ancestors as a child (= no loops in the tree)
- Tasks have a task type, which can be: *Questseries*, *Quest* or *Task* [can be extended....]
- A task of the type *Questseries* can only have children of the type *Quest*
- A task of the type *Quest* can only have children of the type *Task*
- A task of the type *Task* can only have children of the type *Task*
