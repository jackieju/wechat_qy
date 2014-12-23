class Invoice < B1object

    def name
         "invoice"
     end
     def list_column
          ["CardName", "Comments", "JournalMemo", "DocTotal", "DocDate", "DocumentStatus"]
      end
end