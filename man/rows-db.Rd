% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rows-db.R
\name{rows-db}
\alias{rows-db}
\alias{rows_insert.tbl_dbi}
\alias{rows_update.tbl_dbi}
\alias{rows_patch.tbl_dbi}
\alias{rows_upsert.tbl_dbi}
\alias{rows_delete.tbl_dbi}
\alias{sql_rows_insert}
\alias{sql_rows_update}
\alias{sql_rows_patch}
\alias{sql_rows_delete}
\alias{sql_returning_cols}
\alias{sql_output_cols}
\title{Updating database tables}
\usage{
\method{rows_insert}{tbl_dbi}(
  x,
  y,
  by = NULL,
  ...,
  in_place = NULL,
  copy = FALSE,
  check = NULL,
  returning = NULL
)

\method{rows_update}{tbl_dbi}(
  x,
  y,
  by = NULL,
  ...,
  in_place = NULL,
  copy = FALSE,
  check = NULL,
  returning = NULL
)

\method{rows_patch}{tbl_dbi}(
  x,
  y,
  by = NULL,
  ...,
  in_place = NULL,
  copy = FALSE,
  check = NULL,
  returning = NULL
)

\method{rows_upsert}{tbl_dbi}(
  x,
  y,
  by = NULL,
  ...,
  in_place = NULL,
  copy = FALSE,
  check = NULL,
  returning = NULL
)

\method{rows_delete}{tbl_dbi}(
  x,
  y,
  by = NULL,
  ...,
  in_place = NULL,
  copy = FALSE,
  check = NULL,
  returning = NULL
)

sql_rows_insert(x, y, ..., returning_cols = NULL)

sql_rows_update(x, y, by, ..., returning_cols = NULL)

sql_rows_patch(x, y, by, ..., returning_cols = NULL)

sql_rows_delete(x, y, by, ..., returning_cols = NULL)

sql_returning_cols(x, returning_cols, ...)

sql_output_cols(x, returning_cols, output_delete = FALSE, ...)
}
\arguments{
\item{x}{A pair of data frames or data frame extensions (e.g. a tibble).
\code{y} must have the same columns of \code{x} or a subset.}

\item{y}{A pair of data frames or data frame extensions (e.g. a tibble).
\code{y} must have the same columns of \code{x} or a subset.}

\item{by}{An unnamed character vector giving the key columns. The key
values must uniquely identify each row (i.e. each combination of key
values occurs at most once), and the key columns must exist in both \code{x}
and \code{y}.

By default, we use the first column in \code{y}, since the first column is
a reasonable place to put an identifier variable.}

\item{...}{Other parameters passed onto methods.}

\item{in_place}{Should \code{x} be modified in place? This argument is only
relevant for mutable backends (e.g. databases, data.tables).

When \code{TRUE}, a modified version of \code{x} is returned invisibly;
when \code{FALSE}, a new object representing the resulting changes is returned.}

\item{copy}{If \code{x} and \code{y} are not from the same data source,
and \code{copy} is \code{TRUE}, then \code{y} will be copied into the
same src as \code{x}.  This allows you to join tables across srcs, but
it is a potentially expensive operation so you must opt into it.}

\item{check}{Set to \code{TRUE} to always check keys, or \code{FALSE} to never check.
The default is to check only if \code{in_place} is \code{TRUE} or \code{NULL}.

Currently these checks are no-ops and need yet to be implemented.}

\item{returning}{\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
<\code{\link[=tidyr_tidy_select]{tidy-select}}> Columns to return of the inserted data.
Note that also columns not in \code{y} but automatically created when inserting
into \code{x} can be returned, for example the \code{id} column.

Due to upstream limitations, a warning is given if this argument
is passed unquoted.
To avoid the warning, quote the argument manually:
use e.g. \code{returning = quote(everything())} .}

\item{returning_cols}{A character vector of unquote column names
to return, created from the \code{returning} argument.
Methods for database that do not support this should raise an error.}

\item{output_delete}{For \code{sql_output_cols()}, construct the SQL
for a \code{DELETE} operation.}
}
\value{
A tbl object of the same structure as \code{x}.
If \code{in_place = TRUE}, the underlying data is updated as a side effect,
and \code{x} is returned, invisibly. If return columns are specified with
\code{returning} then the resulting tibble is stored in the attribute
\code{returned_rows}. This can be accessed with \code{\link[=get_returned_rows]{get_returned_rows()}}.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

These methods provide a framework for manipulating individual rows
in existing tables.
All operations expect that both existing and new data are presented
in two compatible \link{tbl} objects.

If \code{y} lives on a different data source than \code{x}, it can be copied automatically
by setting \code{copy = TRUE}, just like for \code{\link[dplyr:mutate-joins]{dplyr::left_join()}}.

On mutable backends like databases, these operations manipulate the
underlying storage.
In contrast to all other operations,
these operations may lead to irreversible changes to the underlying database.
Therefore, in-place updates must be requested explicitly with \code{in_place = TRUE}.
By default, an informative message is given.
Unlike \code{\link[=compute]{compute()}} or \code{\link[=copy_to]{copy_to()}}, no new tables are created.

The \verb{sql_rows_*()} functions return the SQL used for the corresponding
\verb{rows_*()} function with \code{in_place = FALSE}.
\code{y} needs to be located on the same data source as \code{x}.

\code{sql_returning_cols()} and \code{sql_output_cols()} construct the SQL
required to support the \code{returning} argument.
Two methods are required, because the syntax for SQL Server
(and some other databases) is vastly different from Postgres and other
more standardized DBs.
}
\examples{
\dontshow{if (rlang::is_installed("dbplyr")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
data <- dbplyr::memdb_frame(a = 1:3, b = letters[c(1:2, NA)], c = 0.5 + 0:2)
data

try(rows_insert(data, tibble::tibble(a = 4, b = "z")))
rows_insert(data, tibble::tibble(a = 4, b = "z"), copy = TRUE)
rows_update(data, tibble::tibble(a = 2:3, b = "w"), copy = TRUE, in_place = FALSE)
rows_patch(data, dbplyr::memdb_frame(a = 1:4, c = 0), in_place = FALSE)

rows_insert(data, dbplyr::memdb_frame(a = 4, b = "z"), in_place = TRUE)
data
rows_update(data, dbplyr::memdb_frame(a = 2:3, b = "w"), in_place = TRUE)
data
rows_patch(data, dbplyr::memdb_frame(a = 1:4, c = 0), in_place = TRUE)
data
\dontshow{\}) # examplesIf}
}
