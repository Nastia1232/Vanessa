#language: ru

@IgnoreOnCIMainBuild
@tree

Функционал: Тестовая фича, для проверки работы тега tree, когда есть комментарий

Сценарий: Проверка иерархии в сценарии
    Когда Вот иерархия с ошибкой
#		И Вот первый шаг закомментирован
		И вот второй шаг
		И вот третий шаг
	И Вот иерархия без ошибки
		Когда Вот первый шаг
#		И Вот второй шаг закомментирован
		И Вот третий шаг
