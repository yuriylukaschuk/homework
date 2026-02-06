Настройте локального пользователя git у себя на компьютере

git init

Изучите содержимое файла конфигурации Git для текущего
репозитория (.git/config)

[core]
	repositoryformatversion = 0 - Версия формата репозитория: оригинальный формат 
	filemode = false - Отслеживание прав доступа к файлам: игнорирует изменения прав доступа (папка создана в Windows)
	bare = false - Тип репозитория: рабочий репозиторий (есть рабочая директория с файлами)
	logallrefupdates = true - Логирование обновлений ссылок: Git записывает логи для всех обновлений ссылок (веток, тегов)
	symlinks = false - Обработка символических ссылок: не поддерживает (на Windows)
	ignorecase = true - Чувствительность к регистру имен файлов: игнорирует регистр в именах файлов (Windows/Mac)


Настройте имя и email пользователя для текущего репозитория

git config user.name "Yuriy Lukaschuk"
git config user.email "yuriy.lukaschuk@gmail.com"

Убедитесь, что файл .git/config изменился соответствующим образом

[core]
	repositoryformatversion = 0
	filemode = false
	bare = false
	logallrefupdates = true
	symlinks = false
	ignorecase = true
[user]
	name = Yuriy Lukaschuk
	email = yuriy.lukaschuk@gmail.com


1. Склонируйте репозиторий к себе на компьютер

На GitHub создан репозиторий homework

Клонирование:

git remote add origin https://github.com/yuriylukaschuk/homework.git
git branch -M main


2. Скачайте файлы по ссылке:
https://drive.google.com/uc?export=download&confirm=no_antivirus&id=1B_b5mg7rRSKSNqwuDb1hGVYQQpHsEc1J

3. Затем распакуйте архив и поместите в каталог с инициированным гит

5. Сделайте 1й коммит:
 Сделайте файлы папки wild_animals отслеживаемыми

 git add wild_animals

 Обратите внимание на файл индекса (.git/index) и папку с объектами (.git/objects)

После выполнения команды git add wild_animals в .git появился файл index, в папке .git/objects начали создаваться папки (2 символа от SHA-1 хэша контрольной суммы содержимого и заголовка) и в них размещены blob-файлы

 Сделайте коммит

 git commit -m "My First Commit"

 Найдите хэш коммита и поместите в новый файл, потом сделайте еще один коммит. Поменялся ли хэш и почему (поменялся/не поменялся)

Вывод команды git commit -m "My First Commit":
[main (root-commit) 43f4689] My First Commit
 4 files changed, 36 insertions(+)
 create mode 100644 wild_animals/index.html
 create mode 100644 wild_animals/pictures/elephant.jpg 
 create mode 100644 wild_animals/pictures/giraffe.jpg  
 create mode 100644 wild_animals/pictures/paw_print.jpg

Из него видно, что хэш коммита 43f4689
Полный хеш получаем командой git log:
commit 43f46894506b46179e6b000886910dca44aaccd9 (HEAD -> main)
Author: Yuriy Lukaschuk <yuriy.lukaschuk@gmail.com>
Date:   Fri Jan 30 10:22:21 2026 +0300

    My First Commit

Создал файл hesh, поместил в него 43f46894506b46179e6b000886910dca44aaccd9.

Делаю git add hesh коммит с комментарием My Second Commit:

Результат git log:
commit 369a97a50eec0d5bfd1e433f2db501d0e8adcc06 (HEAD -> main)
Author: Yuriy Lukaschuk <yuriy.lukaschuk@gmail.com>
Date:   Fri Jan 30 10:44:46 2026 +0300

    My Second Commit

commit 43f46894506b46179e6b000886910dca44aaccd9
Author: Yuriy Lukaschuk <yuriy.lukaschuk@gmail.com>
Date:   Fri Jan 30 10:22:21 2026 +0300

    My First Commit

Хэш изменился (369a97a50eec0d5bfd1e433f2db501d0e8adcc06) потому, что он вычисляется с помощью SHA-1 криптографической хеш-функции на основе содержимого коммита, который состоит из:
1) Объекта дерева корневой директории репозитория
2) Информации о том, кто и когда создал коммит
3) Кто и когда записал коммит в историю репозитория
4) Комментария коммита

6. Сделайте 2й коммит
 Исправьте опечатку в файле index.html (опечатка в слове Elephant)
 Добавьте изменения в индекс: git add .\wild_animals\index.html
 Сделайте коммит: git commit -m "My Third Commit"
 Результат выполнения команды git log

commit 1f7fb061bc1d6f434b6aa2b8b7be97cbacfea11c (HEAD -> main)
Author: Yuriy Lukaschuk <yuriy.lukaschuk@gmail.com>
Date:   Fri Jan 30 10:56:53 2026 +0300

    My Third Commit

commit 369a97a50eec0d5bfd1e433f2db501d0e8adcc06
Author: Yuriy Lukaschuk <yuriy.lukaschuk@gmail.com>
Date:   Fri Jan 30 10:44:46 2026 +0300

    My Second Commit

commit 43f46894506b46179e6b000886910dca44aaccd9
Author: Yuriy Lukaschuk <yuriy.lukaschuk@gmail.com>
Date:   Fri Jan 30 10:22:21 2026 +0300

    My First Commit

7. Создайте новую ветку test из main, добавьте файл, сделайте коммит. Потом создайте из test ветку dev, сделайте коммит. После выполнения описанных действий постройте дерево репозитория и поместите изображение в файл, сделайте коммит.

git branch test - создал
git switch test - переключился на ветку test
Создал файл test-file.txt
git add test-file.txt - добавил в индекс
git commit -m "Add test-file.txt in Test branch" - сделал коммит
git switch -c dev - создал новую ветку dev и переключился на нее
Если попытаться сразу после создания ветки dev из ветки test выполнить коммит командой git commit -m "Create dev branch ad switch git to dev branch", получаем ошибку: 

On branch dev
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        __MACOSX/

nothing added to commit but untracked files present (use "git add" to track)

Поэтому я создал файл echo "Add dev-file.txt in dev branch" > dev-file.txt и закоммитил его: git add dev-file.txt, git commit -m "Add dev-file.txt in dev branch"

Построил дерево репозитория и сохранил его в файл tree.txt командой git log --all --graph --oneline --decorate > tree.txt.

Добавил в индеск все файлы в ветке dev git add . и закоммитил git commit -m "Save all changes"
8. Сделайте мерж main и dev.

Переключился на ветку main git switch main

Изначально в корневой папке 2 файла: test-file.txt пустой и hesh с содержимым: 43f46894506b46179e6b000886910dca44aaccd9

Длеаю мердж:
git merge dev
Updating 7e6ea77..83ac268
Fast-forward
 __MACOSX/._wild_animals                        | Bin 0 -> 220 bytes
 __MACOSX/wild_animals/pictures/._elephant.jpg  | Bin 0 -> 702 bytes
 __MACOSX/wild_animals/pictures/._giraffe.jpg   | Bin 0 -> 513 bytes
 __MACOSX/wild_animals/pictures/._paw_print.jpg | Bin 0 -> 482 bytes
 dev-file.txt                                   | Bin 0 -> 66 bytes
 main-file.txt                                  | Bin 0 -> 70 bytes
 tree.txt                                       | Bin 0 -> 924 bytes
 7 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 __MACOSX/._wild_animals
 create mode 100644 __MACOSX/wild_animals/pictures/._elephant.jpg
 create mode 100644 __MACOSX/wild_animals/pictures/._giraffe.jpg
 create mode 100644 __MACOSX/wild_animals/pictures/._paw_print.jpg
 create mode 100644 dev-file.txt
 create mode 100644 main-file.txt
 create mode 100644 tree.txt

При слиянии веток в ветку main добавилась директория __MACOSX и файлы dev-file.txt, main-file.txt и tree.txt

9. Попробуйте поработать с git stash, внесите изменения, потом используйте stash, перейдите в ветку test, сделайте коммит, вернитесь в main и выполните git stash apply. Какие файлы и как поменялись?

1) В ветке main создал файл file.txt и внес изменения - добавил запись "Add file.txt in main branch" командой echo "Add file.txt in main branch" > file.txt. Не коммичу.

2) Ввел команду git stash. Вывод: No local changes to save

3) Перешел на ветку test командой git switch test.

4) Внес изменения в файл file.txt: echo "Change file.txt in test branch" > file.txt, добавил файл в индекс git add file.txt, создал коммит git commit -m "Change file.txt in test branch"
5) Вернулся в ветку main командой git switch main. Файл file.txt в ветке main отсутствует.

6) После выполнения команды git stash apply. Вывод:
On branch main
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        deleted:    test-file.txt

no changes added to commit (use "git add" and/or "git commit -a")

Но что самое странное, файл file.txt с содержимым "Add file.txt in main branch" не появился. Хотя должен был.

Но все заработало как положено, когда на шаге 2) была введена команда git stash -u (сохранить изменения, включая новые, не добавленные в индекс, файлы)

10. Попробуйте отменить ваши коммиты (команды есть в шпоре, которую я высылал в тг). прочитайте что такое реверт. Как вы думаете когда он необходим?

Вывел список коммитов командой git log --oneline:
83ac268 (HEAD -> main, dev) Save all changes
ee29c7e Add dev-file.txt in dev branch
7e6ea77 Add test-file.txt in Test branch
1f7fb06 My Third Commit
369a97a My Second Commit
43f4689 My First Commit

Отменяю последний коммит: git reset HEAD~1
Получаю git log --oneline:
ee29c7e (HEAD -> main) Add dev-file.txt in dev branch
7e6ea77 Add test-file.txt in Test branch
1f7fb06 My Third Commit
369a97a My Second Commit
43f4689 My First Commit

Отменяю последний коммит: git reset HEAD~1
Получаю git log --oneline:
7e6ea77 (HEAD -> main) Add test-file.txt in Test branch
1f7fb06 My Third Commit
369a97a My Second Commit
43f4689 My First Commit

git reset переносит указатель ветки на переданный коммит.
git revert создает новый коммит, который отменяет действие одного из предыдущих коммитов

Реверт нужен в случаях, когда коммиты отправлены в удаленные репозиторий, при совместной работе в команде, для отмены конкретного коммита в середине истории и когда нужно сохранить историю для аудита.

Все изменения в ветке main закоммитил:
git add .
git commit -m "Сохраняем все изменения, произведенные в ветке main"


11. Ознакомиться с материалом и выполнить практическое задание в конце
статьи. https://smartiqa.ru/courses/git/lesson-5#theory

Текущее содержание ветки залейте в удаленный репозиторий, по нему я и буду проверять.

12. Совершенствуйте свои навыки на платформе https://learngitbranching.js.org/?locale=ru_RU
