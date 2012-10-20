# Daily Quests
## Features
### Adventurer
- Users are *Adventurers*
- *Adventurers* can have *Questseries*, *Quests*, *Tasks* and *Lists* with *Items*.
- *Questseries*, *Quests*, *Tasks*, *Lists* and *Items* can be created as private or public.
- *Adventurers* can invite other *Adventurers* to join them in their *Quests*
- *Adventurers* can share their *List* with other *Adventurers* which will invite them to possible *Quests* created by that *List*

### Questsystem
- a *Task* has 0 to many *Tasks* -> a *Task* is like a tree with variable number of child-*Tasks* at every element.
  - a *Task* cannot have itself or any of its ancestors as a child (= no loops in the tree).
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
  - *Lists* will create a *Quest* to get the *Items* for the *Adventurers* when there is not enough of an *Item*.
  - *Adventurers* can add from all public *Items* that are in the database.
- An *Item* is a material object.


  

## Middle-Term
- An *Adventurer* can define *Types* of *Quests*.
- An *Adventurer* can define a *Timeframe* for *Types*.
- *Quests* of a given *Type* will only be active within the defined *Timeframe*



## Long-term Features
- On completion of a *Quest* the *Adventurer* is awarded the sum of the *Experience* (hereafter called *XP*) of its *Tasks*.
- A *Tasks* *XP* is the sum of the *XP* of its *Tasks*.
* An *Adventurer* can have 0 to many *Professions*.
- An *Adventurer* is awarded less *XP* the more times he has completed the *Quest* or *Questseries*.
