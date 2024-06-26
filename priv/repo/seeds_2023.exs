# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LineReminder.Repo.insert!(%LineReminder.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias LineReminder.Repo
alias LineReminder.Events
alias LineReminder.Notifiers.Event

unless Repo.exists?(Event) do
  events = [
    %{name: "馬太福音[9]", date: ~D[2023-06-20], group: 1},
    %{name: "馬太福音[10]", date: ~D[2023-06-21], group: 1},
    %{name: "馬太福音[11]", date: ~D[2023-06-22], group: 1},
    %{name: "馬太福音[12]", date: ~D[2023-06-23], group: 1},
    %{name: "馬太福音[13]", date: ~D[2023-06-26], group: 1},
    %{name: "馬太福音[14, 15]", date: ~D[2023-06-27], group: 1},
    %{name: "馬太福音[16, 17]", date: ~D[2023-06-28], group: 1},
    %{name: "馬太福音[18]", date: ~D[2023-06-29], group: 1},
    %{name: "馬太福音[19, 20]", date: ~D[2023-06-30], group: 1},
    %{name: "馬太福音[21]", date: ~D[2023-07-03], group: 1},
    %{name: "馬太福音[22]", date: ~D[2023-07-04], group: 1},
    %{name: "馬太福音[23]", date: ~D[2023-07-05], group: 1},
    %{name: "馬太福音[24]", date: ~D[2023-07-06], group: 1},
    %{name: "馬太福音[25]", date: ~D[2023-07-07], group: 1},
    %{name: "馬太福音[26]", date: ~D[2023-07-10], group: 1},
    %{name: "馬太福音[27, 28]", date: ~D[2023-07-11], group: 1},
    %{name: "馬可福音[1, 2]", date: ~D[2023-07-12], group: 1},
    %{name: "馬可福音[3, 4]", date: ~D[2023-07-13], group: 1},
    %{name: "馬可福音[5, 6]", date: ~D[2023-07-14], group: 1},
    %{name: "馬可福音[7, 8]", date: ~D[2023-07-17], group: 1},
    %{name: "馬可福音[9]", date: ~D[2023-07-18], group: 1},
    %{name: "馬可福音[10]", date: ~D[2023-07-19], group: 1},
    %{name: "馬可福音[11, 12]", date: ~D[2023-07-20], group: 1},
    %{name: "馬可福音[13, 14]", date: ~D[2023-07-21], group: 1},
    %{name: "馬可福音[15, 16]", date: ~D[2023-07-24], group: 1},
    %{name: "路加福音[1]", date: ~D[2023-07-25], group: 1},
    %{name: "路加福音[2]", date: ~D[2023-07-26], group: 1},
    %{name: "路加福音[3, 4]", date: ~D[2023-07-27], group: 1},
    %{name: "路加福音[5, 6]", date: ~D[2023-07-28], group: 1},
    %{name: "路加福音[7, 8]", date: ~D[2023-07-31], group: 1},
    %{name: "路加福音[9]", date: ~D[2023-08-01], group: 1},
    %{name: "路加福音[10]", date: ~D[2023-08-02], group: 1},
    %{name: "路加福音[11]", date: ~D[2023-08-03], group: 1},
    %{name: "路加福音[12]", date: ~D[2023-08-04], group: 1},
    %{name: "路加福音[13, 14]", date: ~D[2023-08-07], group: 1},
    %{name: "路加福音[15, 16]", date: ~D[2023-08-08], group: 1},
    %{name: "路加福音[17, 18]", date: ~D[2023-08-09], group: 1},
    %{name: "路加福音[19, 20]", date: ~D[2023-08-10], group: 1},
    %{name: "路加福音[21, 22]", date: ~D[2023-08-11], group: 1},
    %{name: "路加福音[23, 24]", date: ~D[2023-08-14], group: 1},
    %{name: "約翰福音[1, 2]", date: ~D[2023-08-15], group: 1},
    %{name: "約翰福音[3, 4]", date: ~D[2023-08-16], group: 1},
    %{name: "約翰福音[5, 6]", date: ~D[2023-08-17], group: 1},
    %{name: "約翰福音[7, 8]", date: ~D[2023-08-18], group: 1},
    %{name: "約翰福音[9, 10]", date: ~D[2023-08-21], group: 1},
    %{name: "約翰福音[11, 12]", date: ~D[2023-08-22], group: 1},
    %{name: "約翰福音[13, 14]", date: ~D[2023-08-23], group: 1},
    %{name: "約翰福音[15, 16]", date: ~D[2023-08-24], group: 1},
    %{name: "約翰福音[17, 18]", date: ~D[2023-08-25], group: 1},
    %{name: "約翰福音[19, 20, 21]", date: ~D[2023-08-28], group: 1},
    %{name: "使徒行傳[1, 2]", date: ~D[2023-08-29], group: 1},
    %{name: "使徒行傳[3, 4]", date: ~D[2023-08-30], group: 1},
    %{name: "使徒行傳[5, 6]", date: ~D[2023-08-31], group: 1},
    %{name: "使徒行傳[7, 8]", date: ~D[2023-09-01], group: 1},
    %{name: "使徒行傳[9, 10]", date: ~D[2023-09-04], group: 1},
    %{name: "使徒行傳[11, 12]", date: ~D[2023-09-05], group: 1},
    %{name: "使徒行傳[13, 14]", date: ~D[2023-09-06], group: 1},
    %{name: "使徒行傳[15, 16]", date: ~D[2023-09-07], group: 1},
    %{name: "使徒行傳[17, 18, 19]", date: ~D[2023-09-08], group: 1},
    %{name: "使徒行傳[20, 21, 22]", date: ~D[2023-09-11], group: 1},
    %{name: "使徒行傳[23, 24, 25]", date: ~D[2023-09-12], group: 1},
    %{name: "使徒行傳[26, 27, 28]", date: ~D[2023-09-13], group: 1},
    %{name: "羅馬書[1, 2, 3]", date: ~D[2023-09-14], group: 1},
    %{name: "羅馬書[4, 5, 6]", date: ~D[2023-09-15], group: 1},
    %{name: "羅馬書[7, 8]", date: ~D[2023-09-18], group: 1},
    %{name: "羅馬書[9, 10]", date: ~D[2023-09-19], group: 1},
    %{name: "羅馬書[11, 12, 13]", date: ~D[2023-09-20], group: 1},
    %{name: "羅馬書[14, 15, 16]", date: ~D[2023-09-21], group: 1},
    %{name: "哥林多前書[1, 2, 3]", date: ~D[2023-09-22], group: 1},
    %{name: "哥林多前書[4, 5, 6]", date: ~D[2023-09-25], group: 1},
    %{name: "哥林多前書[7, 8, 9]", date: ~D[2023-09-26], group: 1},
    %{name: "哥林多前書[10, 11, 12]", date: ~D[2023-09-27], group: 1},
    %{name: "哥林多前書[13, 14, 15, 16]", date: ~D[2023-09-28], group: 1},
    %{name: "哥林多後書[1, 2, 3]", date: ~D[2023-09-29], group: 1},
    %{name: "哥林多後書[4, 5, 6]", date: ~D[2023-10-02], group: 1},
    %{name: "哥林多後書[7, 8, 9]", date: ~D[2023-10-03], group: 1},
    %{name: "哥林多後書[10, 11, 12, 13]", date: ~D[2023-10-04], group: 1},
    %{name: "加拉太書[1]", date: ~D[2023-10-05], group: 1},
    %{name: "加拉太書[2]", date: ~D[2023-10-06], group: 1},
    %{name: "加拉太書[3]", date: ~D[2023-10-09], group: 1},
    %{name: "加拉太書[4, 5, 6]", date: ~D[2023-10-10], group: 1},
    %{name: "以弗所書[1, 2, 3]", date: ~D[2023-10-11], group: 1},
    %{name: "以弗所書[4, 5, 6]", date: ~D[2023-10-12], group: 1},
    %{name: "腓立比書[1, 2]", date: ~D[2023-10-13], group: 1},
    %{name: "腓立比書[3, 4]", date: ~D[2023-10-16], group: 1},
    %{name: "歌羅西書[1, 2]", date: ~D[2023-10-17], group: 1},
    %{name: "歌羅西書[3, 4]", date: ~D[2023-10-18], group: 1},
    %{name: "帖撒羅尼迦前書[1, 2]", date: ~D[2023-10-19], group: 1},
    %{name: "帖撒羅尼迦前書[3, 4, 5]", date: ~D[2023-10-20], group: 1},
    %{name: "帖撒羅尼迦後書[1, 2, 3]", date: ~D[2023-10-23], group: 1},
    %{name: "提摩太前書[1, 2, 3]", date: ~D[2023-10-24], group: 1},
    %{name: "提摩太前書[4, 5, 6]", date: ~D[2023-10-25], group: 1},
    %{name: "提摩太後書[1, 2, 3, 4]", date: ~D[2023-10-26], group: 1},
    %{name: "提多書[1, 2, 3]", date: ~D[2023-10-27], group: 1},
    %{name: "腓利門書", date: ~D[2023-10-30], group: 1},
    %{name: "希伯來書[1, 2, 3]", date: ~D[2023-10-31], group: 1},
    %{name: "希伯來書[4, 5, 6]", date: ~D[2023-11-01], group: 1},
    %{name: "希伯來書[7, 8, 9]", date: ~D[2023-11-02], group: 1},
    %{name: "希伯來書[10, 11]", date: ~D[2023-11-03], group: 1},
    %{name: "希伯來書[12, 13]", date: ~D[2023-11-06], group: 1},
    %{name: "雅各書[1, 2]", date: ~D[2023-11-07], group: 1},
    %{name: "雅各書[3, 4, 5]", date: ~D[2023-11-08], group: 1},
    %{name: "彼得前書[1, 2]", date: ~D[2023-11-09], group: 1},
    %{name: "彼得前書[3, 4, 5]", date: ~D[2023-11-10], group: 1},
    %{name: "彼得後書[1, 2, 3]", date: ~D[2023-11-13], group: 1},
    %{name: "約翰一書[1, 2, 3]", date: ~D[2023-11-14], group: 1},
    %{name: "約翰一書[4, 5]", date: ~D[2023-11-15], group: 1},
    %{name: "約翰二、三書", date: ~D[2023-11-16], group: 1},
    %{name: "猶大書", date: ~D[2023-11-17], group: 1},
    %{name: "啟示錄[1, 2]", date: ~D[2023-11-20], group: 1},
    %{name: "啟示錄[3, 4]", date: ~D[2023-11-21], group: 1},
    %{name: "啟示錄[5, 6, 7]", date: ~D[2023-11-22], group: 1},
    %{name: "啟示錄[8, 9, 10]", date: ~D[2023-11-23], group: 1},
    %{name: "啟示錄[11, 12, 13]", date: ~D[2023-11-24], group: 1},
    %{name: "啟示錄[14, 15, 16]", date: ~D[2023-11-27], group: 1},
    %{name: "啟示錄[17, 18]", date: ~D[2023-11-28], group: 1},
    %{name: "啟示錄[19, 20]", date: ~D[2023-11-29], group: 1},
    %{name: "啟示錄[21, 22]", date: ~D[2023-11-30], group: 1}
  ]

  Repo.transaction(fn ->
    Enum.each(events, fn event ->
      Events.create_event(event)
    end)
  end)
end
