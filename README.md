# Daily Quests
## Features
### Hero
- Users are *Heroes*
- *Heroes* can have *Questseries*, *Quests*, *Tasks* and *Lists* with *Items*.
- *Questseries*, *Quests*, *Tasks*, *Lists* and *Items* can be created as private or public.
- *Heroes* can invite other *Heroes* to join them in their *Quests*
- *Heroes* can share their *List* with other *Heroes* which will invite them to possible *Quests* created by that *List*

### Questsystem
- A *Task* has 0 to many *Tasks* -> a *Task* is like a tree with variable number of child-*Tasks* at every element.
  - A *Task* cannot have itself or any of its ancestors as a child (= no loops in the tree).
  - *Tasks* have a *Task* type, which can be: *Questseries*, *Quest* or *Task* [can be extended....].
    - A *Task* of the type *Questseries* can only have children of the type *Quest*.
    - A *Task* of the type *Quest* can only have children of the type *Task*.
      - A *Quest* can be active or inactive.
      - A *Quest* will create *Reminders* at a (hopefully) convenient time of the day.
      - Inactive *Quests* do not generate reminders.
    - A *Task* of the type *Task* can only have children of the type *Task*.
    - A *Task* of the type *Questseries* or *Quest* can be recurring, recreating themselves on completion.


### Inventory
- A *List* is a collection of *Items* [a Questfactory creating *Quests* when needed]
  - *Items* in *Lists* have a target amount
  - *Lists* will create a *Quest* to get the *Items* for the *Heroes* when there is not enough of an *Item*.
  - *Heroes* can add from all public *Items* that are in the database.
- An *Item* is a material object.


## Middle-Term Features
- An *Hero* can define *Types* of *Quests*.
- An *Hero* can define a *Timeframe* for *Types*.
- *Quests* of a given *Type* will only be active within the defined *Timeframe*


## Long-Term Features
- On completion of a *Quest* the *Hero* is awarded the sum of the *Experience* (hereafter called *XP*) of its *Tasks*.
- A *Tasks* *XP* is the sum of the *XP* of its *Tasks*.
- An *Hero* can have 0 to many *Professions*.
- An *Hero* is awarded less *XP* the more times he has completed the *Quest* or *Questseries*.
- There will be *Guilds* where users can easily compare their *XP* and other stuff....
