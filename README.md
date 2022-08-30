# Тестовое

Тестовое задание взято у [appKODE](https://kode.ru/) с публичного репозитория [gitHub](https://github.com/appKODE/trainee-test-ios). </p>
Для удобства чтения все **Pull Request(ы)** и **Commit(ы)** будут на русском языке.</p>

---

### _Содержание_

1. [Функционал](#функционал)
2. [Описание фичей](#описание-фичей)
3. [Не сделано](#не-сделано)
4. [FAQ](#faq)

## Функционал

Для ознакомления с устройством фичи можно заглянуть в истории Pull Request(ов).

<table>
	<thead>
		<tr>
			<th>Launch</th>
			<th>Search</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				<img width="250" src="https://user-images.githubusercontent.com/89836599/187421246-9ad404de-09ae-4a79-914c-1c9e35549286.gif">
			</td>
			<td>
				<img width="250" src="https://user-images.githubusercontent.com/89836599/187451493-140476eb-f4e4-4ac0-8629-13056353bbba.gif">
			</td>
		</tr>
	</tbody>
</table>

<table>
	<thead>
		<tr>
			<th>Filer</th>
			<th>Localization</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				<img width="250" src="https://user-images.githubusercontent.com/89836599/187465721-315a8a89-a184-467b-8f8d-572b602653cc.gif">
			</td>
			<td>
				<img width="250" src="https://user-images.githubusercontent.com/89836599/187460195-13a18691-0cdc-4ab9-9c19-272a6dea5d36.gif">
			</td>
		</tr>
	</tbody>
</table>

<table>
	<thead>
		<tr>
			<th>Internet Error</th>
			<th>Internal Error</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				<img width="250" src="https://user-images.githubusercontent.com/89836599/187455384-4d615977-eda9-4e1a-aee5-f3ed4e83c70a.gif">
			</td>
			<td>
				<img width="250" src="https://user-images.githubusercontent.com/89836599/187457061-d3fcc7df-ee2e-4952-88f4-f1bbd16b9a7b.gif">
			</td>
		</tr>
	</tbody>
</table>

<table>
	<thead>
		<tr>
			<th>Call</th>
			<th>Pull to Refresh</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				<img width="250" src="https://user-images.githubusercontent.com/89836599/187468932-14641d58-3131-46dc-9770-b6e80d1ab32b.gif">
			</td>
			<td>
				<img width="250" src="https://user-images.githubusercontent.com/89836599/187469911-45bdfcdf-6f35-49bf-8ada-5c379163be67.gif">
			</td>
		</tr>
	</tbody>
</table>

## Описание фичей

1. Launch:
	* Кастомный экран запуска
	* UI-cкелет во время загрузки данных с сервера
	* Сохранение и установление последней вкладки
2. Search
	* Поиск по Имени
	* Поиск по Тегу
	* Ошибка поиска (не найдено)
3. Filter
	* Фильтрация по алфавиту
	* Фильтрация по дню рождения (возрастание)
4. Localization
	* Локализация Русского языка
	* Локализация Английского языка
5. Error
	* Обработка ошибки с подключением к интернету
	* Обработка внутренних ошибок с сервера
6. Details
	* Вызов при нажатии на номер
	* Закрытие экрана по pop-свайпу
7. Pull to refresh
 	* Если потянуть таблицу — обновятся пользователи
8. Figma like design
	* Склонение год/года/лет
 	* Номер телефона по маске
	* Первые 3 буквы месяца
	* Язычок в заголовке модального экрана
	* Поле ввода по макету: фильтр-кнопка и лупа-кнопка меняют цвет в соответствии состояния поля

## Не сделано

- [ ] Темная тема
- [ ] Юнит-тестирование
- [ ] [UISheetPresentationController](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller?changes=latest_minor) при >iOS14 
- [ ] Кастомный анимированный индикатор обновления ([анимация](https://material.angular.io/components/progress-spinner/overview))
- [ ] Свайп для перехода между вкладками (как в Telegram)
- [ ] Реактивщина: [RxSwift](https://github.com/ReactiveX/RxSwift) || [Combine](https://developer.apple.com/documentation/combine)

## FAQ

>Библиотеки использовать можно свободно на своё усмотрение, но будет круче, если сделать всё самостоятельно.

Q: Можешь ли аргументировать почему использовал [SnapKit](https://github.com/SnapKit/SnapKit)?  </br>
Q: Почему выбрал в качестве архитектуры — [MVVM](https://www.wikiwand.com/ru/Model-View-ViewModel)? </br>
A: Во-первых, на сколько мне известно, KODE используют эти технологии, соответственно мне захотелось сделать все приближено к вашим условиям. Во-вторых, до этого не использовал ни то, ни другое, а верстать через NSLayoutConstraint и Anchors вроде умею ([пример](https://github.com/okidokimiki/marvelgram-ios)). Потому решил сделать небольшой челлендж. </p>

Q: С каким трудностями столкнулся? </br>
A: Идти сразу в реактивщину, не зная ни MVVM, ни одного фреймворка – плохая идея ). Какое-то время не мог понять причину ошибки загрузки картинок с сервера (`HTTPHeader: dynamic=true`). Ну, еще можно выделить передачу данных с модального окна назад на топ, и работу с датой. Так что, наверное, все как у людей :). </p>

Q: Не вижу раздела с затраченным временем, почему? </br>
A: Тк, я не сразу стал выполнять задание, а какое-то время потратил на изучение вышесказанного, то не смог зафиксировать затраченное время. Однако, ушло примерно ±1.5 недели на все с условием, что тратил примерно 2-4 часа в день (в выходные отдыхал — лето 🙃 ).
