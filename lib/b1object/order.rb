class Invoice < B1object

    def name
         "order"
     end
     def list_column
          ["CardName", "Comments", "JournalMemo", "DocTotal", "DocDate", "DocumentStatus"]
      end
end