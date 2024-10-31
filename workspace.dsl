workspace {
    name "FaceBook"
    description "Социальная сеть"

    model {
        user = person "Пользователь" {}

        socialNetwork = softwareSystem "Социальная сеть" {
            description "Платформа для социального взаимодействия пользователей"

            userService = container "User Service" {
                description "Управление пользователями и их данными"
                technology "Python, Flask"
            }

            postService = container "Post Service" {
                description "Управление постами и стенами пользователей"
                technology "Python, Flask"
            }

            messageService = container "Message Service" {
                description "Управление сообщениями между пользователями"
                technology "Python, Flask"
            }

            db = container "DataBase" {
                description "Общая база данных для всех сервисов"
                technology "PostgreSQL"
            }

            db_cache = container "Cache" {
                description "Кэш для быстрого доступа к данным"
                technology "Redis"
            }

            frontend = container "Web Site" {
                description "Визуальный интерфейс"
                technology "HTML, CSS, JS"
            }

            userService -> db "Читает и записывает данные о пользователях"
            postService -> db "Читает и записывает посты"
            messageService -> db "Читает и записывает сообщения"
            
            userService -> db_cache "Читает и записывает данные/Быстро"
            postService -> db_cache "Читает и записывает данные/Быстро"
            messageService -> db_cache "Читает и записывает данные/Быстро"
            
            db_cache -> db "Запрашивает недостающие данные"

            frontend -> userService "Запросы к пользователям"
            frontend -> postService "Запросы к постам"
            frontend -> messageService "Запросы к сообщениям"
        }

        user -> frontend "Использует"
    }

    views {
        dynamic socialNetwork "uc01" "Запросы к сервисам" {
            autoLayout lr
            frontend -> userService "Создание нового пользователя"
            userService -> db "POST/new_user/ {login:<>,password:<>}"

            frontend -> userService "Поиск пользователя по логину"
            userService -> db "GET/get_user/login=<>" 

            frontend -> userService "Поиск пользователя по маске имя и фамилия"
            userService -> db "GET/get_user_by_name/name=<>,surname=<>" 

            frontend -> postService "Добавление записи на стену"
            postService -> db "POST/create_post/ {login:<>, password:<>, content:<>}" 

            frontend -> postService "Загрузка стены пользователя"            
            postService -> db "GET/get_user_wall/login=<>" 

            frontend -> messageService "Отправка сообщения пользователю"
            messageService -> db "POST/send_a_message/{login=<>,password=<>,target=<>,body=<>}" 

            frontend -> messageService "Получение списка сообщений для пользователя"        
            messageService -> db "GET/get_chat/login=<>,target=<>" 
        }

        themes default 
        systemContext socialNetwork "ContextDiagram" {
            include *
            autoLayout lr
        }
        container socialNetwork {
            include *
            autoLayout lr
        }
    }
}
