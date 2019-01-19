response = HTTPoison.get!("http://10.31.22.94:8283/api/coursesBanner/201912")
all201889 = response.body |> Poison.decode

parse_date = fn d ->
    e = NaiveDateTime.from_iso8601! d
    "#{e.year}-#{e.month}-#{e.day}"
end

format_hours = fn h ->
    case is_nil(h) do
        true -> "00:00"
        false ->
            << x::bytes-size(2),y::bytes-size(2) >> = h
            "#{x}:#{y}"
    end
end

all201889_fields = for c <- all201889,
                    do: {
                        c["nrc"],
                        [c["nrc"],
                        parse_date.(c["startDate"]),
                        parse_date.(c["endDate"]),
                        format_hours.(c["beginTime"]),
                        format_hours.(c["endTime"]),
                        c["monday"],
                        c["tuesday"],
                        c["wednesday"],
                        c["thursday"],
                        c["friday"],
                        c["saturday"],
                        c["sunday"]]
                    }
comparator = fn {c1,_}, {c2,_} -> c1 < c2 end
all201889_fields |> Enum.sort(comparator)
sorted_tuples = all201889_fields |> Enum.sort(comparator)
for {_, c} <- sorted_tuples, do: c

{:ok, file} = File.open "postgres.csv", [:write]

fulltext = (for {_, c} <- sorted_tuples, do: c) |> Enum.map(fn c -> Enum.join(c,",") end) |> Enum.join("\n")
IO.binwrite file, fulltext
File.close file